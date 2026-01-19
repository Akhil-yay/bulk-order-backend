<?php

$conn = new mysqli("localhost", "root", "", "bulk_order_system", 3306);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->begin_transaction();

try {

    
    $orders = $conn->query("
        SELECT * FROM orders 
        WHERE status = 'NEW' 
        FOR UPDATE
    ");

    while ($order = $orders->fetch_assoc()) {

        
        $courierQuery = "
            SELECT c.courier_id 
            FROM couriers c
            JOIN courier_locations cl ON c.courier_id = cl.courier_id
            WHERE cl.city = '{$order['city']}'
              AND cl.zone = '{$order['zone']}'
              AND c.active = 1
              AND c.current_assigned_count < c.daily_capacity
            ORDER BY c.current_assigned_count ASC
            LIMIT 1
        ";

        $courier = $conn->query($courierQuery)->fetch_assoc();

        if (!$courier) {
            
            continue;
        }

        
        $conn->query("
            INSERT INTO order_assignments (order_id, courier_id, status)
            VALUES ({$order['order_id']}, {$courier['courier_id']}, 'SUCCESS')
        ");

        
        $conn->query("
            UPDATE orders 
            SET status = 'ASSIGNED'
            WHERE order_id = {$order['order_id']}
        ");

        
        $conn->query("
            UPDATE couriers 
            SET current_assigned_count = current_assigned_count + 1
            WHERE courier_id = {$courier['courier_id']}
        ");
    }

        $conn->commit();
    echo "Bulk assignment completed successfully";

} catch (Exception $e) {
    $conn->rollback();
    echo "Assignment failed: " . $e->getMessage();
}

