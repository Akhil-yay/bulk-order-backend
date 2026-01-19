-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 19, 2026 at 04:00 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bulk_order_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `couriers`
--

CREATE TABLE `couriers` (
  `courier_id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `daily_capacity` int(11) NOT NULL,
  `current_assigned_count` int(11) DEFAULT 0,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `couriers`
--

INSERT INTO `couriers` (`courier_id`, `name`, `daily_capacity`, `current_assigned_count`, `active`, `created_at`) VALUES
(1, 'BlueDart', 2, 2, 1, '2026-01-19 13:17:43'),
(2, 'Delhivery', 3, 1, 1, '2026-01-19 13:17:43');

-- --------------------------------------------------------

--
-- Table structure for table `courier_locations`
--

CREATE TABLE `courier_locations` (
  `id` bigint(20) NOT NULL,
  `courier_id` bigint(20) NOT NULL,
  `city` varchar(50) NOT NULL,
  `zone` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courier_locations`
--

INSERT INTO `courier_locations` (`id`, `courier_id`, `city`, `zone`) VALUES
(1, 1, 'Delhi', 'South'),
(2, 2, 'Delhi', 'South');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` bigint(20) NOT NULL,
  `order_date` datetime NOT NULL,
  `city` varchar(50) NOT NULL,
  `zone` varchar(50) NOT NULL,
  `order_value` decimal(10,2) DEFAULT NULL,
  `status` enum('NEW','ASSIGNED','UNASSIGNED') DEFAULT 'NEW',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `order_date`, `city`, `zone`, `order_value`, `status`, `created_at`) VALUES
(1, '2026-01-19 18:47:43', 'Delhi', 'South', 450.00, 'ASSIGNED', '2026-01-19 13:17:43'),
(2, '2026-01-19 18:47:43', 'Delhi', 'South', 600.00, 'ASSIGNED', '2026-01-19 13:17:43'),
(3, '2026-01-19 18:47:43', 'Delhi', 'South', 300.00, 'ASSIGNED', '2026-01-19 13:17:43');

-- --------------------------------------------------------

--
-- Table structure for table `order_assignments`
--

CREATE TABLE `order_assignments` (
  `assignment_id` bigint(20) NOT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `courier_id` bigint(20) DEFAULT NULL,
  `assignment_date` datetime DEFAULT current_timestamp(),
  `status` enum('SUCCESS','FAILED') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_assignments`
--

INSERT INTO `order_assignments` (`assignment_id`, `order_id`, `courier_id`, `assignment_date`, `status`) VALUES
(1, 1, 1, '2026-01-19 19:03:19', 'SUCCESS'),
(2, 2, 2, '2026-01-19 19:03:19', 'SUCCESS'),
(3, 3, 1, '2026-01-19 19:03:19', 'SUCCESS');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `couriers`
--
ALTER TABLE `couriers`
  ADD PRIMARY KEY (`courier_id`),
  ADD KEY `idx_active` (`active`);

--
-- Indexes for table `courier_locations`
--
ALTER TABLE `courier_locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courier_id` (`courier_id`),
  ADD KEY `idx_location` (`city`,`zone`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_order_status` (`status`),
  ADD KEY `idx_order_location` (`city`,`zone`);

--
-- Indexes for table `order_assignments`
--
ALTER TABLE `order_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `courier_id` (`courier_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `couriers`
--
ALTER TABLE `couriers`
  MODIFY `courier_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `courier_locations`
--
ALTER TABLE `courier_locations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_assignments`
--
ALTER TABLE `order_assignments`
  MODIFY `assignment_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courier_locations`
--
ALTER TABLE `courier_locations`
  ADD CONSTRAINT `courier_locations_ibfk_1` FOREIGN KEY (`courier_id`) REFERENCES `couriers` (`courier_id`);

--
-- Constraints for table `order_assignments`
--
ALTER TABLE `order_assignments`
  ADD CONSTRAINT `order_assignments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_assignments_ibfk_2` FOREIGN KEY (`courier_id`) REFERENCES `couriers` (`courier_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
