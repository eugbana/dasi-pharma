-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2026 at 10:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dasipharma`
--

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Branch name',
  `code` varchar(20) NOT NULL COMMENT 'Unique branch code for internal reference',
  `address` text DEFAULT NULL COMMENT 'Physical address',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Contact phone number',
  `email` varchar(100) DEFAULT NULL COMMENT 'Contact email',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Active status flag',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`id`, `name`, `code`, `address`, `phone`, `email`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'qqDasi Pharma - Ikeja', 'IKJ', '4g Allen Avenue, Ikeja, Lagos State', '+234 803 123 4567', 'ikeja@dasipharma.ng', 1, '2026-01-10 17:52:43', '2026-01-23 23:18:52', '2026-01-23 23:18:52'),
(2, 'Dasi Pharma - Victoria Island', 'VI', '12 Adeola Odeku Street, Victoria Island, Lagos State', '+234 803 234 5678', 'vi@dasipharma.ng', 1, '2026-01-10 17:52:43', '2026-01-10 22:56:27', '2026-01-10 22:56:27'),
(3, 'Dasi Pharma - Abuja', 'ABJ', '78 Gimbiya Street, Garki, Abuja FCT', '+234 803 345 6789', 'abuja@dasipharma.ng', 1, '2026-01-10 17:52:43', '2026-01-10 22:56:32', '2026-01-10 22:56:32'),
(4, 'Dasi Pharma - Port Harcourt', 'PHC', '23 Aba Road, Port Harcourt, Rivers State', '+234 803 456 7890', 'portharcourt@dasipharma.ng', 1, '2026-01-10 17:52:43', '2026-01-10 22:52:55', '2026-01-10 22:52:55'),
(5, 'dsfvsdsdfvds', 'sdfvsdfvsdfv', 'dfsvsdfvsdfv', NULL, NULL, 0, '2026-01-10 22:49:11', '2026-01-10 22:53:02', '2026-01-10 22:53:02'),
(6, 'svsdvcsdf', 'sdfvsdfvsd', 'sdfvsdfvsdf', NULL, NULL, 1, '2026-01-10 22:50:37', '2026-01-10 22:53:44', '2026-01-10 22:53:44'),
(7, 'RYANS WELLNESS PHARMACY', 'ryua', 'NO1 pizhi close area 1 garki', NULL, NULL, 1, '2026-01-23 09:44:39', '2026-01-23 09:44:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Category name (e.g., Pharmaceuticals, Vitamins)',
  `slug` varchar(255) NOT NULL COMMENT 'URL-friendly slug',
  `description` text DEFAULT NULL COMMENT 'Category description',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Active status',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Display order',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(2, 'Pharmaceuticals', 'pharmaceuticals', 'Drugs', 1, 2, '2026-01-10 18:51:36', '2026-01-10 18:51:36'),
(4, 'Superstore', 'superstore', NULL, 1, 4, '2026-01-23 09:26:19', '2026-01-23 09:26:19');

-- --------------------------------------------------------

--
-- Table structure for table `drugs`
--

CREATE TABLE `drugs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `brand_name` varchar(255) NOT NULL COMMENT 'Brand/trade name',
  `generic_name` varchar(255) DEFAULT NULL,
  `strength` varchar(50) DEFAULT NULL,
  `dosage_form` varchar(50) DEFAULT NULL,
  `manufacturer` varchar(255) DEFAULT NULL COMMENT 'Manufacturer name',
  `barcode` varchar(50) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subcategory_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_prescription_only` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Requires prescription flag',
  `controlled_substance_class` enum('Schedule II','Schedule III','Schedule IV','Schedule V') DEFAULT NULL COMMENT 'Controlled substance classification',
  `description` text DEFAULT NULL COMMENT 'Product description',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `barcode_active` tinyint(1) GENERATED ALWAYS AS (`deleted_at` is null) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `drugs`
--

INSERT INTO `drugs` (`id`, `brand_name`, `generic_name`, `strength`, `dosage_form`, `manufacturer`, `barcode`, `category_id`, `subcategory_id`, `is_prescription_only`, `controlled_substance_class`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Paracetamol', 'Paracetamol', '500mg', 'Tablet', 'Emzor Pharmaceutical', NULL, NULL, NULL, 0, NULL, 'Pain reliever and fever reducer', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(2, 'Ibuprofen', 'Ibuprofen', '400mg', 'Tablet', 'GlaxoSmithKline', NULL, NULL, NULL, 0, NULL, 'Non-steroidal anti-inflammatory drug (NSAID)', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(3, 'Tramadol', 'Tramadol Hydrochloride', '50mg', 'Capsule', 'Juhel Nigeria Limited', NULL, NULL, NULL, 1, 'Schedule IV', 'Opioid pain medication - CONTROLLED SUBSTANCE', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(4, 'Amoxicillin', 'Amoxicillin', '500mg', 'Capsule', 'Fidson Healthcare', NULL, NULL, NULL, 1, NULL, 'Penicillin antibiotic', '2026-01-10 17:52:45', '2026-01-13 16:59:48', '2026-01-13 16:59:48'),
(5, 'Ciprofloxacin', 'Ciprofloxacin', '500mg', 'Tablet', 'Ranbaxy', NULL, NULL, NULL, 1, NULL, 'Fluoroquinolone antibiotic', '2026-01-10 17:52:45', '2026-04-12 16:13:10', '2026-04-12 16:13:10'),
(6, 'Azithromycin', 'Azithromycin', '250mg', 'Tablet', 'Pfizer', NULL, 2, NULL, 1, NULL, 'Macrolide antibiotic', '2026-01-10 17:52:45', '2026-04-12 16:07:35', '2026-04-12 16:07:35'),
(7, 'Coartem', 'Artemether-Lumefantrine', '20/120mg', 'Tablet', 'Novartis', NULL, NULL, NULL, 0, NULL, 'Artemisinin-based combination therapy for malaria', '2026-01-10 17:52:45', '2026-04-12 16:14:43', '2026-04-12 16:14:43'),
(8, 'Lonart', 'Artemether-Lumefantrine', '80/480mg', 'Tablet', 'Bliss GVS Pharma', NULL, NULL, NULL, 0, NULL, 'Antimalarial combination therapy', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(9, 'Amlodipine', 'Amlodipine Besylate', '5mg', 'Tablet', 'Emzor Pharmaceutical', NULL, NULL, NULL, 1, NULL, 'Calcium channel blocker for hypertension', '2026-01-10 17:52:45', '2026-01-13 16:59:34', '2026-01-13 16:59:34'),
(10, 'Lisinopril', 'Lisinopril', '10mg', 'Tablet', 'Merck', NULL, NULL, NULL, 1, NULL, 'ACE inhibitor for hypertension', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(11, 'Metformin', 'Metformin Hydrochloride', '500mg', 'Tablet', 'Fidson Healthcare', NULL, NULL, NULL, 1, NULL, 'Oral antidiabetic medication', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(12, 'Glibenclamide', 'Glibenclamide', '5mg', 'Tablet', 'Sanofi', NULL, NULL, NULL, 1, NULL, 'Sulfonylurea for type 2 diabetes', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(13, 'Vitamin C', 'Ascorbic Acid', '1000mg', 'Tablet', 'Emzor Pharmaceutical', NULL, NULL, NULL, 0, NULL, 'Vitamin C supplement', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(14, 'Multivitamin', 'Multivitamin Complex', 'Standard', 'Tablet', 'Vitabiotics', NULL, NULL, NULL, 0, NULL, 'Daily multivitamin supplement', '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(15, 'Benylin', 'Dextromethorphan', '100ml', 'Syrup', 'Johnson & Johnson', NULL, NULL, NULL, 0, NULL, 'Cough suppressant syrup', '2026-01-10 17:52:45', '2026-04-12 16:08:30', '2026-04-12 16:08:30'),
(16, 'Neofylin Cough Syrup 100ml(Mopson)', 'Cough Syrup', '100ml', NULL, 'Mopson', '6154000295004', 2, 11, 0, NULL, NULL, '2026-01-10 19:32:55', '2026-04-18 09:34:12', '2026-04-18 09:34:12'),
(17, 'rtgrtgrtgrtg', NULL, NULL, NULL, NULL, 'rtgrtgrtgrtgt', 2, NULL, 0, NULL, NULL, '2026-01-23 09:23:22', '2026-01-24 23:49:01', '2026-01-24 23:49:01'),
(18, 'Camry', 'Weight Scale', NULL, NULL, NULL, '6922227100131', 4, NULL, 0, NULL, NULL, '2026-01-23 09:27:38', '2026-01-23 09:27:38', NULL),
(19, 'ddddd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-01-24 01:00:02', '2026-01-24 23:48:39', '2026-01-24 23:48:39'),
(20, 'Husamco', 'Bottle Water', NULL, NULL, NULL, '659886033222', 4, NULL, 0, NULL, NULL, '2026-01-24 19:48:24', '2026-01-24 19:48:24', NULL),
(21, 'pan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-01-24 23:28:32', '2026-01-24 23:48:49', '2026-01-24 23:48:49'),
(22, 'Kellogg\'s Corn Flakes 300g', NULL, NULL, NULL, NULL, '6154000317850', 4, NULL, 0, NULL, NULL, '2026-03-28 12:00:35', '2026-03-28 12:00:35', NULL),
(23, 'Dogan\'s Sugar x90 Cubes', NULL, NULL, NULL, NULL, '6156000124339', 4, NULL, 0, NULL, NULL, '2026-03-28 12:10:16', '2026-03-28 12:10:16', NULL),
(24, 'Gloden Penny White Sugar x90 Cubes 500g', NULL, NULL, NULL, NULL, '6156000051512', 4, NULL, 0, NULL, NULL, '2026-03-28 12:17:30', '2026-03-28 12:17:30', NULL),
(25, 'Sniper Multipurpose Insect Killer 300ml', NULL, NULL, NULL, NULL, '6154000113018', 4, NULL, 0, NULL, NULL, '2026-03-28 12:20:36', '2026-03-28 12:20:36', NULL),
(26, 'Sniper Crawling Insect Killer 300ml', NULL, NULL, NULL, NULL, '6154000113155', 4, NULL, 0, NULL, NULL, '2026-03-28 12:26:52', '2026-03-28 12:26:52', NULL),
(27, 'Sniper Flying Insect Killer 300ml', NULL, NULL, NULL, NULL, '6154000113070', 4, NULL, 0, NULL, NULL, '2026-03-28 12:30:39', '2026-03-28 12:30:39', NULL),
(28, 'Peak Milk Full Cream Powder Pouch 350g', NULL, NULL, NULL, NULL, '8716200449342', 4, NULL, 0, NULL, NULL, '2026-03-28 12:35:25', '2026-03-28 12:35:25', NULL),
(29, 'Three Crowns Istant Filled Milk Powder 320g', NULL, NULL, NULL, NULL, '6156000092188', 4, NULL, 0, NULL, NULL, '2026-03-28 12:42:12', '2026-03-28 12:42:12', NULL),
(30, 'Cadbwry Hot Chocolate Drink 3in1 450g', NULL, NULL, NULL, NULL, '7622201139100', 4, NULL, 0, NULL, NULL, '2026-03-28 12:50:35', '2026-03-28 12:50:35', NULL),
(31, 'Lipton Yellow Label Tea x25 Bags', NULL, NULL, NULL, NULL, '8720608603145', 4, NULL, 0, NULL, NULL, '2026-03-28 12:55:24', '2026-03-28 12:55:24', NULL),
(32, 'Be Tres Melon Body Mist 100ml', NULL, NULL, NULL, NULL, '6936829066443', 4, NULL, 0, NULL, NULL, '2026-03-28 12:57:44', '2026-03-28 12:57:44', NULL),
(33, 'Joy Expert Care Black Soap with Shea Butter & Aloe 150g', NULL, NULL, NULL, NULL, '6151100311412', 4, NULL, 0, NULL, NULL, '2026-03-28 13:00:22', '2026-03-28 13:00:22', NULL),
(34, 'Be Tres Mora Body Mist 100ml', NULL, NULL, NULL, NULL, '6936829066436', 4, NULL, 0, NULL, NULL, '2026-03-28 13:05:27', '2026-03-28 13:05:27', NULL),
(35, 'Titus Sardines in Vegetable Oil 125g', NULL, NULL, NULL, NULL, 'TITUS25G', 4, NULL, 0, NULL, NULL, '2026-03-28 13:05:50', '2026-04-12 16:59:13', NULL),
(36, 'Be Tres Coco Body Mist 100ml', NULL, NULL, NULL, NULL, '6936829066412', 4, NULL, 0, NULL, NULL, '2026-03-28 13:11:03', '2026-03-29 13:53:43', NULL),
(37, 'Peak Filled Evaporated Milk lite & Creamy Tin 150g', NULL, NULL, NULL, NULL, '6154000054151', 4, NULL, 0, NULL, NULL, '2026-03-28 13:14:53', '2026-03-28 13:14:53', NULL),
(38, 'Good Knight Multi Insect Killer Lemon Fragrance 700ml', NULL, NULL, NULL, NULL, '8901023021930', 4, NULL, 0, NULL, NULL, '2026-03-28 13:19:08', '2026-03-28 13:19:08', NULL),
(39, 'Nestle Golden Morn Maize & Soya Protein Cereal 900g', NULL, NULL, NULL, NULL, '6033000681515', 4, NULL, 0, NULL, NULL, '2026-03-28 13:30:44', '2026-03-28 13:30:44', NULL),
(40, 'Be Tres Vainilla Body Mist 100ml', NULL, NULL, NULL, NULL, '6936829066429', 4, NULL, 0, NULL, NULL, '2026-03-28 13:31:30', '2026-03-28 13:31:30', NULL),
(41, 'Nivea Black & White Invisible(Clear) Anti-Perspirant Body Spray 200ml', NULL, NULL, NULL, NULL, '4005900034847', 4, NULL, 0, NULL, NULL, '2026-03-28 13:35:26', '2026-03-28 14:55:55', NULL),
(42, 'Checkers Custard Powder Vanilla Flavour 400g', NULL, NULL, NULL, NULL, '6152110065975', 4, NULL, 0, NULL, NULL, '2026-03-28 13:38:48', '2026-03-28 13:38:48', NULL),
(43, 'Nivea Men Black & White Invisible(Original)Body Spray 200ml', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-03-28 13:39:19', '2026-03-28 14:52:14', '2026-03-28 14:52:14'),
(44, 'Checkers Custard Powder Banana Flavour 1kg', NULL, NULL, NULL, NULL, '782706100139', 4, NULL, 0, NULL, NULL, '2026-03-28 13:43:39', '2026-03-28 13:43:39', NULL),
(45, 'Nivea Men Black&White Invisible(Original) Body Spray 200ml', NULL, NULL, NULL, NULL, '4005900736109', 4, NULL, 0, NULL, NULL, '2026-03-28 13:45:21', '2026-03-28 14:52:40', NULL),
(46, 'Nivea Dry Comfort Anti-Perspirant Body Spray 200ml', NULL, NULL, NULL, NULL, '4005808905997', 4, NULL, 0, NULL, NULL, '2026-03-28 13:50:14', '2026-03-28 14:53:25', NULL),
(47, 'Hypo Multipurpose Bleach Kill 99.9 500ml', NULL, NULL, NULL, NULL, '6156000039619', 4, NULL, 0, NULL, NULL, '2026-03-28 13:51:05', '2026-03-28 13:51:05', NULL),
(48, 'Nivea Men Deep Dry & Clean Anti-Perspirant Body spray 200ml', NULL, NULL, NULL, NULL, '4005900745637', 4, NULL, 0, NULL, NULL, '2026-03-28 14:05:04', '2026-03-28 14:56:18', NULL),
(49, 'Hollandia Yoghurt Drink Sweetened 500ml', NULL, NULL, NULL, NULL, '6151100054753', 4, NULL, 0, NULL, NULL, '2026-03-28 14:05:07', '2026-03-28 14:05:07', NULL),
(50, 'Amstel Malta Malt Drink No Alcohol', NULL, NULL, NULL, NULL, '5025866000082', 4, NULL, 0, NULL, NULL, '2026-03-28 14:09:41', '2026-03-28 14:09:41', NULL),
(51, 'Riggs London Icon Body Spray 250ml', NULL, NULL, NULL, NULL, '5060340392437', 4, NULL, 0, NULL, NULL, '2026-03-28 14:11:30', '2026-03-28 15:00:46', NULL),
(52, 'Riggs London Night Body Spray 250ml', NULL, NULL, NULL, NULL, '5060340397524', 4, NULL, 0, NULL, NULL, '2026-03-28 14:14:49', '2026-03-28 14:57:04', NULL),
(53, 'Riggs London Dynamo Body Spray 250ml', NULL, NULL, NULL, NULL, '5060340392345', 4, NULL, 0, NULL, NULL, '2026-03-28 14:17:27', '2026-03-28 15:01:14', NULL),
(54, 'Peak Full Cream Evaporated Milk Rich & Creamy Tin 139ml', NULL, NULL, NULL, NULL, '87162240', 4, NULL, 0, NULL, NULL, '2026-03-28 14:17:42', '2026-03-29 14:06:11', NULL),
(55, 'Riggs London Only Body Spray 250ml', NULL, NULL, NULL, NULL, '5060340398149', 4, NULL, 0, NULL, NULL, '2026-03-28 14:19:28', '2026-03-28 14:57:37', NULL),
(56, 'Harpic Power Plus 10x Mountain Pine 450ml', NULL, NULL, NULL, NULL, '6151100281074', 4, NULL, 0, NULL, NULL, '2026-03-28 14:25:22', '2026-03-28 14:25:22', NULL),
(57, 'Nivea Radiant&Beauty (Even Glow) Body Lotion 400ml', NULL, NULL, NULL, NULL, '4005900925046', 4, NULL, 0, NULL, NULL, '2026-03-28 14:25:22', '2026-03-29 13:57:55', NULL),
(58, 'Nestle Milo Energy Food Drink 400g', NULL, NULL, NULL, NULL, '6033000684752', 4, NULL, 0, NULL, NULL, '2026-03-28 14:27:38', '2026-03-28 14:27:38', NULL),
(59, 'Nivea Radiant& Beauty (Advanced Care)Body Lotion 400ml', NULL, NULL, NULL, NULL, '4005900925022', 4, NULL, 0, NULL, NULL, '2026-03-28 14:29:54', '2026-03-29 13:57:03', NULL),
(60, 'Colgate Maximum Cavity Protection 130g', NULL, NULL, NULL, NULL, '8718951704831', 4, NULL, 0, NULL, NULL, '2026-03-28 14:32:06', '2026-03-28 14:32:06', NULL),
(61, 'Nivea Rich Nourishing Body Lotion 400ml', NULL, NULL, NULL, NULL, '4005900378170', 4, NULL, 0, NULL, NULL, '2026-03-28 14:32:35', '2026-03-28 14:55:09', NULL),
(62, 'Cussons Morning Fresh Diswashing Liquid Zesty Lemon 450ml', NULL, NULL, NULL, NULL, '6154000018139', 4, NULL, 0, NULL, NULL, '2026-03-28 14:36:49', '2026-03-28 14:36:49', NULL),
(63, 'Nivea Perfect & Radiant Body Lotion 400ml', NULL, NULL, NULL, NULL, '4005900378606', 4, NULL, 0, NULL, NULL, '2026-03-28 14:38:27', '2026-03-29 13:51:20', NULL),
(64, 'Jik Multipurpose Bleach Regular 475ml', NULL, NULL, NULL, NULL, '6151100282071', 4, NULL, 0, NULL, NULL, '2026-03-28 14:40:36', '2026-03-28 14:40:36', NULL),
(65, 'Nestle Golden Morn Maize & Soya Protein 300g', NULL, NULL, NULL, NULL, '6033000681492', 4, NULL, 0, NULL, NULL, '2026-03-28 14:49:49', '2026-03-28 14:51:34', NULL),
(66, 'Familia Ultra 2Kitchen Rolls x6', NULL, NULL, NULL, NULL, 'FAMILIA2', 4, NULL, 0, NULL, NULL, '2026-03-28 14:51:10', '2026-04-12 16:36:21', NULL),
(67, 'Bama Mayonnaise 385ml', NULL, NULL, NULL, NULL, '8410300367680', 4, NULL, 0, NULL, NULL, '2026-03-29 14:11:03', '2026-03-29 14:11:03', NULL),
(68, 'Cussons Carex H/Wash Original 250ml', NULL, NULL, NULL, NULL, '6154000017934', 4, NULL, 0, NULL, NULL, '2026-03-29 14:17:51', '2026-03-29 14:17:51', NULL),
(69, 'Cussons Carex H/Wash Moisture Plus 250ml', NULL, NULL, NULL, NULL, '6154000018481', 4, NULL, 0, NULL, NULL, '2026-03-29 14:21:07', '2026-03-29 14:21:07', NULL),
(70, 'Vaseline Blueseal Pure Petroleum Gel(Original)225ml', NULL, NULL, NULL, NULL, '6151100133458', 4, NULL, 0, NULL, NULL, '2026-03-29 14:24:00', '2026-03-29 14:24:00', NULL),
(71, 'Oral-B ToothPaste Family Size 130g', NULL, NULL, NULL, NULL, '8001090583420', 4, NULL, 0, NULL, NULL, '2026-03-29 14:26:54', '2026-03-29 14:26:54', NULL),
(72, 'Siri African Marigold Bar Soap 150g', NULL, NULL, NULL, NULL, '745110908241', 4, NULL, 0, NULL, NULL, '2026-03-29 14:30:13', '2026-03-29 14:30:13', NULL),
(73, 'Premier Cool Ultra Moisture Black Soap 110g', NULL, NULL, NULL, NULL, '6151100311160', 4, NULL, 0, NULL, NULL, '2026-03-29 14:32:42', '2026-03-29 14:32:42', NULL),
(74, 'Eva Bar Soap(Romantic) 150g', NULL, NULL, NULL, NULL, '6154000005184', 4, NULL, 0, NULL, NULL, '2026-03-29 14:35:57', '2026-03-29 14:35:57', NULL),
(75, 'Eva Bar Soap (Classic) 150g', NULL, NULL, NULL, NULL, '6154000269180', 4, NULL, 0, NULL, NULL, '2026-03-29 14:40:28', '2026-03-29 14:40:28', NULL),
(76, 'FreshYo Yoghurt Sweetened 375ml X12', NULL, NULL, NULL, NULL, '6154000102487', 4, NULL, 0, NULL, NULL, '2026-03-29 14:46:01', '2026-03-29 14:50:47', NULL),
(77, 'Sosa Fruit Drink Orange 35cl x12', NULL, NULL, NULL, NULL, '6154000082413', 4, NULL, 0, NULL, NULL, '2026-03-29 14:48:41', '2026-03-29 14:48:41', NULL),
(78, 'Sosa Fruit Drink Cranberry 35cl x12', NULL, NULL, NULL, NULL, '6154000082420', 4, NULL, 0, NULL, NULL, '2026-03-29 14:51:55', '2026-03-29 14:51:55', NULL),
(79, 'Lucozade Boost Energy Drink Pet 450ml', NULL, NULL, NULL, NULL, '6161113670192', 4, NULL, 0, NULL, NULL, '2026-03-29 14:53:33', '2026-03-29 14:53:33', NULL),
(80, 'Ribena BlackCurrent Fruit Drink 450ml', NULL, NULL, NULL, NULL, '6161113670239', 4, NULL, 0, NULL, NULL, '2026-03-29 14:56:51', '2026-03-29 14:56:51', NULL),
(81, 'Chivita Exotic Pineapple & Coconut Nectar Drink 1Lt x10', NULL, NULL, NULL, NULL, '6151100051219', 4, NULL, 0, NULL, NULL, '2026-03-29 15:00:12', '2026-03-29 15:02:17', NULL),
(82, 'Familia Kitchen Roll x6', NULL, NULL, NULL, NULL, '8690536023165', 4, NULL, 0, NULL, NULL, '2026-03-29 15:10:19', '2026-03-29 15:10:19', NULL),
(83, 'Familia Toilet Tissues Roll x6 Pcs Roll', NULL, NULL, NULL, NULL, '8690536023127', 4, NULL, 0, NULL, NULL, '2026-03-29 15:21:14', '2026-03-29 15:21:14', NULL),
(84, 'Softcare Baby Wipes x60pcs', NULL, NULL, NULL, NULL, '6156000394237', 4, NULL, 0, NULL, NULL, '2026-03-29 15:23:51', '2026-03-29 15:23:51', NULL),
(85, 'Besense Sanitary Pads', NULL, NULL, NULL, NULL, '608887086775', 4, NULL, 0, NULL, NULL, '2026-03-29 15:26:38', '2026-03-29 16:37:12', '2026-03-29 16:37:12'),
(86, 'Besense Sanitary Pads', NULL, NULL, NULL, NULL, 'Besense100', 4, NULL, 0, NULL, NULL, '2026-03-29 16:32:03', '2026-03-29 16:38:49', NULL),
(87, 'Angel Baby Wipes x125Pcs', NULL, NULL, NULL, NULL, '769658790007', 4, NULL, 0, NULL, NULL, '2026-03-29 16:40:17', '2026-03-29 16:40:17', NULL),
(88, 'My Girl Sanitary Pads', NULL, NULL, NULL, NULL, '640712830146', 4, NULL, 0, NULL, NULL, '2026-03-29 16:43:16', '2026-03-29 16:43:16', NULL),
(89, 'Softcare Sanitary Pad', NULL, NULL, NULL, NULL, '6156000349237', 4, NULL, 0, NULL, NULL, '2026-03-29 16:45:45', '2026-03-29 16:45:45', NULL),
(90, 'Toda Special Serviette', NULL, NULL, NULL, NULL, '6152110063889', 4, NULL, 0, NULL, NULL, '2026-03-29 16:49:49', '2026-03-29 16:49:49', NULL),
(91, 'Amoxil 500mg Amoxicillin 10x10Caps(GSK Group)', 'Amoxicillin', NULL, NULL, NULL, '8901040105231', 2, NULL, 0, NULL, NULL, '2026-04-03 09:28:37', '2026-04-03 10:21:38', NULL),
(92, 'Dr Meyer\'s Asmanol-F x50Tabs(Vitabiotics Nig. Ltd)', NULL, NULL, NULL, NULL, 'ASMANOL50', 2, NULL, 0, NULL, NULL, '2026-04-03 09:37:15', '2026-04-12 16:33:14', NULL),
(93, 'Alfamether Arteether Injection 3x2ml(Grace Pharma/Agron Remedice Pvt Ltd)', NULL, NULL, NULL, NULL, '8908017282940', 2, NULL, 0, NULL, NULL, '2026-04-03 09:41:32', '2026-04-03 09:41:32', NULL),
(94, 'Nazamox 250mg Amoxicillin 10x10Caps(Sinopharm Weiqida Pharma/Naza)', NULL, NULL, NULL, 'Naza Pharmacy Ltd', '6972544372827', 2, NULL, 0, NULL, NULL, '2026-04-03 09:45:57', '2026-04-03 09:45:57', NULL),
(95, 'Amoxil 125mg/5ml Suspension 100ml (GSK Group  Of Company)', 'Amoxicillin', '125mg', NULL, 'GlaxoSmithKline', 'Amoxil125', 2, NULL, 0, NULL, NULL, '2026-04-03 09:54:27', '2026-04-03 10:20:25', NULL),
(96, 'Ampiclox 500mg 10x10Caps(GSK Group Of Company)', 'Ampicillin/Cloxacillin', '500mg', NULL, 'GlaxosmithKline', 'Ampiclox001', 2, NULL, 0, NULL, NULL, '2026-04-03 09:57:49', '2026-04-03 10:22:49', NULL),
(97, 'Astarclox 500mg Ampicillin/Cloxacillin 10x10Caps(Sam-Ace Ltd)', 'Ampicillin/Cloxacillin', '500mg', NULL, 'Sam-Ace Ltd', 'Astra500', 2, NULL, 0, NULL, NULL, '2026-04-03 10:05:22', '2026-04-03 10:23:50', NULL),
(98, 'Folimop Folic Acid Syrup 2.5mg/5ml Mopson 100ml', 'Folic acid', '2.5mg', 'syrup', NULL, '6154000295141', 2, NULL, 0, NULL, NULL, '2026-04-03 10:07:12', '2026-04-03 10:07:12', NULL),
(99, 'BabyRex Baby Mixture 60ml(Tuyil Pharma Ind. Ltd)', NULL, '60ml', NULL, 'Tuyil Pharma Ind. Ltd', 'RexBaby1', 2, NULL, 0, NULL, NULL, '2026-04-03 10:10:26', '2026-04-03 10:24:37', NULL),
(100, 'Ferobin Plus Iron, Folic Acid, Vit, Minerals 200ml', 'Iron, Vitamins and Minerals', NULL, 'syrup', NULL, '6151100490483', 2, NULL, 0, NULL, NULL, '2026-04-03 10:14:06', '2026-04-03 10:14:06', NULL),
(101, 'Laboplex Vitamin B-Complex Inject. 10x10ml(Laborate Pharma (India)', 'Vitamin B-Complex', '10ml', NULL, 'Laborate Pharma (India)', 'LABOPLEX', 2, NULL, 0, NULL, NULL, '2026-04-03 10:16:18', '2026-04-12 16:40:27', NULL),
(102, 'First Aid Kit MayaSalis Small Size', NULL, NULL, NULL, NULL, 'MAYASALIS-FIRSTAID', 2, NULL, 0, NULL, NULL, '2026-04-03 10:19:22', '2026-04-03 10:54:09', NULL),
(103, 'Griseofulvin 20tabs 500mg Chupet Pharm', 'Griseofulvin', '500mg', 'tablet', NULL, 'CHUPET-500MG', 2, 4, 0, NULL, NULL, '2026-04-03 10:25:30', '2026-04-03 10:25:30', NULL),
(104, 'Throtal Erythromycin Oral Suspension 125mg/5ml(Mopson)', 'Erythromycin', '125mg/5ml', NULL, 'Mopson Pharma Ltd', '0659436289888', 2, NULL, 0, NULL, NULL, '2026-04-03 10:29:37', '2026-04-03 10:32:51', NULL),
(105, 'Flucamed Fluconazole 50mg x3 Caps DGF', 'Fluconazole', '50mg', 'capsule', NULL, '6156000158198', 2, 4, 0, NULL, NULL, '2026-04-03 10:30:57', '2026-04-03 10:30:57', NULL),
(106, 'Flucamed Fluconazole 200mg x10 Caps DGF', 'Fluconazole', '200mg', 'capsule', 'Drugfield Pharma', '6156000127576', 2, 4, 0, NULL, NULL, '2026-04-03 10:34:51', '2026-04-03 10:34:51', NULL),
(107, 'Biocine Lincomycin 250mg/5ml Syrup 100ml(DGF)', 'Lincomycin', '250mg/5ml', NULL, 'DrugField (DGF)', '6156000127545', 2, NULL, 0, NULL, NULL, '2026-04-03 10:35:45', '2026-04-03 10:35:45', NULL),
(108, 'Flucamed Fluconazole 10mg/1ml Powder Suspension 35ml  DGF', 'Fluconazole', '10mg', 'syrup', NULL, '6156000127637', 2, 4, 0, NULL, NULL, '2026-04-03 10:38:31', '2026-04-03 10:38:31', NULL),
(109, 'Bunto Blood Tonic 300ml(Tuyil Pharma. Indu Ltd)', 'Blood Builder', '300ml', NULL, 'Tuyil Pharma Ltd', 'bBUNTO01', 2, NULL, 0, NULL, NULL, '2026-04-03 10:41:05', '2026-04-03 10:49:06', NULL),
(110, 'Bunto Blood Tonic 100ml(Tuyil Pharma Ind. Ltd)', 'Blood Builder', '100ml', NULL, 'Tuyil Pharma Ind Ltd', 'BUNT02', 2, NULL, 0, NULL, NULL, '2026-04-03 10:44:57', '2026-04-03 10:48:24', NULL),
(111, 'Artery Forcept', NULL, NULL, NULL, NULL, 'ARTERY-FORCEPT', 2, 5, 0, NULL, NULL, '2026-04-03 10:50:02', '2026-04-03 10:53:10', NULL),
(112, 'Moko Calamine Lotion 100ml(New Healthway  Co. Ltd)', 'Calamine', '100ml', NULL, 'New Healthway  Co. Ltd', '6156000058771', 2, 6, 0, NULL, NULL, '2026-04-03 11:02:46', '2026-04-03 11:02:46', NULL),
(113, 'Crepe Bandage 3 Inch', 'Bandage', NULL, NULL, NULL, 'CREPE3INCH', 2, 5, 0, NULL, NULL, '2026-04-03 11:07:41', '2026-04-12 16:31:30', NULL),
(114, 'Gestid Plus 180ml With Ginger Aniseed Mint', NULL, NULL, 'syrup', NULL, 'GESTIDPLUS-180ML', 2, 7, 0, NULL, NULL, '2026-04-03 11:08:27', '2026-04-03 12:12:52', NULL),
(115, 'Galcipro TN Cipro 500mg + Tinidazole 600mg 10 tabs SKG', NULL, '500mg/600mg', 'tablet', 'SKG', '608887011746', 2, 8, 0, NULL, NULL, '2026-04-03 11:24:36', '2026-04-03 11:24:36', NULL),
(116, 'Cefuroxime 500mg 1x10Tabs(Fidson)', 'Cefuroxime', '500mg', NULL, 'Fidson', '280900', 2, NULL, 0, NULL, NULL, '2026-04-03 11:25:18', '2026-04-03 11:28:44', NULL),
(117, 'Gazgo Simethicone 200mg 3x10 Caps MEGA /card', 'Simethicone', '200mg', 'capsule', NULL, '8850769015935', 2, 7, 0, NULL, NULL, '2026-04-03 11:31:36', '2026-04-03 11:31:36', NULL),
(118, 'Cenox 500mg Ciprofloxacin(Elbe Pharma Nig Ltd)', 'Ciprofloxacin', '500mg', NULL, 'Elbe Pharma Nig. Ltd', '8906003878603', 2, 8, 0, NULL, NULL, '2026-04-03 11:31:42', '2026-04-03 11:31:42', NULL),
(119, 'Cetidyn-L 5mg Levocetirizine 5x10Caplets(Phamatex Indu. Ltd)', 'Levocetirizine', '5mg', NULL, 'Phamatex Indu. Ltd', '6154000309015', 2, 6, 0, NULL, NULL, '2026-04-03 11:36:41', '2026-04-03 11:36:41', NULL),
(120, 'Gauze Bandages 7.5cm x 4.5m', NULL, NULL, NULL, NULL, 'GAUZE-BANDAGE-3INCH', 2, 5, 0, NULL, NULL, '2026-04-03 11:38:23', '2026-04-03 11:38:23', NULL),
(121, 'Chemiron Blood Capsules 10x12Caps', 'Chemiron', NULL, NULL, 'Chemiron Care Ltd', 'Chemiron11', 2, 9, 0, NULL, NULL, '2026-04-03 11:43:01', '2026-04-03 11:45:55', NULL),
(122, 'Gauze Bandages 15cm x 4.5m 6\"x5 YDS', NULL, NULL, NULL, NULL, 'GAUZE-BANDAGE-6INCH', 2, 5, 0, NULL, NULL, '2026-04-03 11:44:04', '2026-04-03 11:44:04', NULL),
(123, 'Chemiron Blood Tonic 100ml', 'Chemiron', '100ml', NULL, 'Chemiron Care Ltd', 'BT044CHEM', 2, 9, 0, NULL, NULL, '2026-04-03 11:48:48', '2026-04-03 11:51:14', NULL),
(124, 'Gbomoro Syrup 100ml NMS', NULL, NULL, 'syrup', NULL, '6152110057314', 2, 10, 0, NULL, NULL, '2026-04-03 11:52:15', '2026-04-03 11:52:15', NULL),
(125, 'Original Chest & Lung 2x10Tabs *Per Card(Galaxy Pharma(India)', NULL, NULL, NULL, 'Galaxy Pharma(India)', 'CHEST451', 2, 11, 0, NULL, NULL, '2026-04-03 11:57:21', '2026-04-17 12:54:43', NULL),
(126, 'Glucose D with Calcium and Vitamin D 400g Tin Evans', NULL, NULL, NULL, 'Evans', '6156000351407', 2, NULL, 0, NULL, NULL, '2026-04-03 11:58:49', '2026-04-03 11:58:49', NULL),
(127, 'Gentamycin Injection 80mg/2ml I.M./I.V. /ampoul', 'Gentamicin', '80mg', 'injection', NULL, 'GENTAMYCIN-INJ', 2, 8, 0, NULL, NULL, '2026-04-03 12:04:31', '2026-04-03 12:04:31', NULL),
(128, 'Mupiderm Mupirocin Ointment 15g(Aquatix Pharma Ltd)', 'Mupirocin', '15g', NULL, 'Aquatix Pharma Ltd', 'MUPIDE3200', 2, 4, 0, NULL, NULL, '2026-04-03 12:04:58', '2026-04-03 12:07:22', NULL),
(129, 'Moko Glycerin Borax Mouthwash NHW 50ml', NULL, NULL, NULL, NULL, '6156000058832', 2, NULL, 0, NULL, NULL, '2026-04-03 12:10:22', '2026-04-03 12:10:22', NULL),
(130, 'Zanef Cefuroxime Suspension 125mg/5ml 100ml(Afri Generics Pharma Ltd)', 'Cefuroxime', '125mg/5ml', NULL, 'Afri Generics Pharma. Ltd', '8904181402238', 2, 8, 0, NULL, NULL, '2026-04-03 12:12:32', '2026-04-03 12:12:32', NULL),
(131, 'Gestid Suspension 200ml', NULL, NULL, 'syrup', 'Sun Pharmaceutical', 'GESTID-200ML', 2, 7, 0, NULL, NULL, '2026-04-03 12:15:51', '2026-04-03 12:15:51', NULL),
(132, 'Salbutamol 0.5mg/1ml Inject. 10x1ml Ampo(Alliaance Biotech)', 'Salbutamol', NULL, NULL, 'Alliaance Biotech', '8905063005554', 2, 6, 0, NULL, NULL, '2026-04-03 12:16:21', '2026-04-03 12:16:21', NULL),
(133, 'Giving Set Hypo Flow I.V. Infusion Set', NULL, NULL, 'injection', NULL, 'GIVINGSET', 2, 5, 0, NULL, NULL, '2026-04-03 12:20:34', '2026-04-12 16:37:58', NULL),
(134, 'Ciprotab 500mg Ciprofloxacin x10 soflets (Fidson Healthcare Plc)(Fidson)', 'Ciprofloxacin', '500mg', NULL, 'Fidson', '8906001825258', 2, 8, 0, NULL, NULL, '2026-04-03 12:20:36', '2026-04-04 12:00:49', NULL),
(135, 'Glothrox 500mg Azithromycin 1x10Caps', 'Azithromycin', '500mg', NULL, 'Relax Biotech Pvt Ltd', '8906024342220', 2, 8, 0, NULL, NULL, '2026-04-03 12:24:37', '2026-04-03 12:24:37', NULL),
(136, 'Moko Gentian Violet Paint 0.5% w/v 60ml NHW', NULL, NULL, NULL, NULL, '6156000058757', 2, 5, 0, NULL, NULL, '2026-04-03 12:25:00', '2026-04-03 12:25:00', NULL),
(137, 'Ocefix 200mg Cefixime 1x10Tabs(Swipha)', 'Cefixime', '200mg', NULL, 'Swipha', '8906035499203', 2, 8, 0, NULL, NULL, '2026-04-03 12:27:56', '2026-04-03 12:27:56', NULL),
(138, 'Hydrogen Peroxide B.P. Galways 100ml SKG', NULL, NULL, NULL, 'SKG', 'HYDROGEN-100ML', 2, 5, 0, NULL, NULL, '2026-04-03 12:30:43', '2026-04-03 12:30:43', NULL),
(139, 'SamJones Levofloxacin 500mg 1x10Tabs(Globela Pharma Pvt. Ltd)', NULL, '500mg', NULL, 'Dezubik Pharmacy Ltd/Globela Pharma Pvt. Ltd)', '8906045625395', 2, 8, 0, NULL, NULL, '2026-04-03 12:33:29', '2026-04-03 12:33:29', NULL),
(140, 'Zadol Forte x10Tabs(Kingzy Pharma Ltd)', 'Aceclofenac', NULL, NULL, 'Kingzy Pharma Ltd', '8906046351583', 2, 10, 0, NULL, NULL, '2026-04-03 12:40:36', '2026-04-03 12:40:36', NULL),
(141, 'Sorepils Sore Throat,& Cough Lozengens (Orange)x24Loze(Lozen Pharma Pvt. Ltd)', 'Lozenges', NULL, NULL, 'Lozen Pharma Pvt. Ltd', '8906093670163', 2, 11, 0, NULL, NULL, '2026-04-03 12:47:12', '2026-04-03 12:47:12', NULL),
(142, 'Hyoscin Butylbromide Injection 10mg/ml Nelcopan /Ampoule', NULL, NULL, 'injection', NULL, 'HYOSCIN-INJ', 2, NULL, 0, NULL, NULL, '2026-04-03 12:47:24', '2026-04-03 12:47:24', NULL),
(143, 'Ibuprofen Suspension 100mg/5ml 100ml Afrab', NULL, NULL, 'syrup', 'Afrab-Chem ltd', '6154000240219', 2, 10, 0, NULL, NULL, '2026-04-03 12:50:56', '2026-04-03 12:50:56', NULL),
(144, 'Flucor Day Non-Drowsy(Hovid)', NULL, NULL, NULL, 'Hovid', '9556100106261', 2, 6, 0, NULL, NULL, '2026-04-03 12:52:30', '2026-04-03 12:52:30', NULL),
(145, 'Moko Iodine Tincture B.P.C. 15ml NHW', NULL, NULL, NULL, NULL, '6156000058801', 2, 5, 0, NULL, NULL, '2026-04-03 12:54:53', '2026-04-03 12:54:53', NULL),
(146, 'Jawasil Antacid Suspension 200ml Jawa', NULL, NULL, 'syrup', 'JAWA', '6154000056186', 2, 7, 0, NULL, NULL, '2026-04-03 12:58:52', '2026-04-03 12:58:52', NULL),
(147, 'Cetroxol Azithromycin 500mg x3Tabs', 'Azithromycin', '500mg', NULL, NULL, 'CETRO12', 2, 8, 0, NULL, NULL, '2026-04-03 13:00:08', '2026-04-03 13:02:22', NULL),
(148, 'Jawamox Amoxycillin Suspension 125mg/5ml 100ml', NULL, '125mg', 'syrup', NULL, 'JAWAMOX-125MG', 2, 8, 0, NULL, NULL, '2026-04-03 13:02:12', '2026-04-03 13:02:12', NULL),
(149, 'Jawaclox Ampicillin/Cloxacillin Suspension 250mg/5ml 100ml', NULL, '250mg', 'syrup', NULL, '6154000056070', 2, 8, 0, NULL, NULL, '2026-04-03 13:08:56', '2026-04-03 13:08:56', NULL),
(150, 'Uniglove Examination Glove(Unicare)', 'Gloves', NULL, NULL, 'Uni-Medical Healthcare Ltd', '5060264110131', 2, 5, 0, NULL, NULL, '2026-04-03 13:11:12', '2026-04-03 13:11:12', NULL),
(151, 'Jesse Nasal Inhaler', NULL, NULL, NULL, NULL, 'JESSE-INHALER', 2, NULL, 0, NULL, NULL, '2026-04-03 13:16:00', '2026-04-03 13:16:00', NULL),
(152, 'Robb Inhealer x12(PZ Cussons Nig. Plc)', 'Robb', '1g', NULL, 'PZ Cussons Nig. Plc', '6008879066688', 2, 13, 0, NULL, NULL, '2026-04-03 13:17:04', '2026-04-03 13:17:04', NULL),
(153, 'Pythrocin 500mg Azithromycin 1x10Tabs(Globela Pharma Pvt Ltd)', 'Azithromycin', '500mg', NULL, 'Globela Pharma Pvt Ltd/Pinnacle', 'PYTH21', 2, 8, 0, NULL, NULL, '2026-04-03 13:23:27', '2026-04-03 13:25:28', NULL),
(154, 'Keep-On Emulsion 450ml SKG', NULL, NULL, 'syrup', 'SKG', '608887048865', 2, 12, 0, NULL, NULL, '2026-04-03 13:24:38', '2026-04-03 13:26:32', NULL),
(155, 'Ketofung Ketoconazole 200mg tabs DGF /Card', NULL, '200mg', 'tablet', 'Drugfield', 'KETOFUNG-200MG', 2, 4, 0, NULL, NULL, '2026-04-03 13:30:17', '2026-04-03 13:30:17', NULL),
(156, 'Koyomine Promethazine 25mg tabs Mancare /Card', NULL, '25mg', 'tablet', 'Mancare Pharma', '18906062952709', 2, 6, 0, NULL, NULL, '2026-04-03 13:38:45', '2026-04-03 13:41:13', NULL),
(157, 'Pyrantrin 125mg(Nemeth Internal. Pharma. Plc)', NULL, '125mg', NULL, 'Nemeth Internal. Pharma. Plc', NULL, 2, 15, 0, NULL, NULL, '2026-04-03 13:39:51', '2026-04-03 13:39:51', NULL),
(158, 'Labcin-500 Erythromycin 500mg 10tabs Embassy', NULL, '500mg', 'tablet', 'Embassy Pharma', '08906045941532', 2, 8, 0, NULL, NULL, '2026-04-03 13:43:45', '2026-04-03 13:43:45', NULL),
(159, 'Terlev-750 Levofloxacin 1x10Tabs(MicroLab)', 'Levofloxacin', '750', NULL, 'MicroLab', 'Tervel01', 2, 8, 0, NULL, NULL, '2026-04-03 13:43:53', '2026-04-03 14:09:42', NULL),
(160, 'Strepsils Soothing Honey & Lemon Lozenges x24(Reckitt Benckiser Healthcare)', 'Strepsils', NULL, NULL, 'Reckitt Benckiser Healthcare', '5000158103757', 2, 11, 0, NULL, NULL, '2026-04-03 13:49:14', '2026-04-03 13:49:14', NULL),
(161, 'Strepsils Lozenges Original x24Lozen((Reckitt Benckiser Healthcare', 'Lozengees', NULL, NULL, '(Reckitt Benckiser Healthcare', '5000158103764', 2, 11, 0, NULL, NULL, '2026-04-03 13:54:47', '2026-04-03 13:54:47', NULL),
(162, 'M&B CIPRO 500mg Ciprofloxacin 14tabs', NULL, '500mg', 'tablet', 'May & Baker', '6151006000052', 2, 8, 0, NULL, NULL, '2026-04-03 13:55:21', '2026-04-03 13:55:21', NULL),
(163, 'Phillips\' Milk of Magnesia Liquid UK 200ml', NULL, NULL, 'syrup', 'Omega Pharma', '5012616291791', 2, 7, 0, NULL, NULL, '2026-04-03 13:58:49', '2026-04-03 13:58:49', NULL),
(164, 'Vega 100mg Sildenafil 4tabs Signature', NULL, '100mg', 'tablet', NULL, '1890604538950', 2, 17, 0, NULL, NULL, '2026-04-03 14:03:00', '2026-04-03 14:03:00', NULL),
(165, 'Spanische Fliege 100ml(WR Pharmace.Germany)', NULL, '100ml', NULL, 'WR Pharmace.Germany', 'SPANISCHE-100', 2, 17, 0, NULL, NULL, '2026-04-03 14:03:29', '2026-04-12 14:59:14', NULL),
(166, 'Tadalis-20 Tadalafil x4Tabs(Evans Therapeutics Ltd)', 'Tadalafil', '20mg', NULL, 'Evans Therapeut. Ltd', '8901117460218', 2, 17, 0, NULL, NULL, '2026-04-03 14:07:24', '2026-04-03 14:07:24', NULL),
(167, 'Deleject Disposable Needles 21G Green /Strip', NULL, NULL, 'injection', NULL, 'DELEJECT-21G', 2, 5, 0, NULL, NULL, '2026-04-03 14:09:27', '2026-04-03 14:09:27', NULL),
(168, 'Agary Fine-Can Needles 23G Blue /Strip', NULL, NULL, 'injection', 'Agary Pharma', '4032855012156', 2, 5, 0, NULL, NULL, '2026-04-03 14:13:49', '2026-04-03 14:15:21', NULL),
(169, 'Permesop Esomeprazole 20mg tabs Reals /Card', NULL, '20mg', NULL, NULL, '4806510883562', 2, 7, 0, NULL, NULL, '2026-04-03 14:19:42', '2026-04-03 14:19:42', NULL),
(170, 'Terlev-500 Levofloxacin 1x10tabs(MicroLab)', NULL, '500mg', NULL, 'MicroLab', 'TELEV500', 2, 8, 0, NULL, NULL, '2026-04-03 14:26:48', '2026-04-12 16:58:47', NULL),
(171, 'WellKiD Baby & Infant 3 Month to 5yrs 150ml Vitabiotics', NULL, NULL, 'syrup', 'Vitabiotics', '5021265223855', 2, 12, 0, NULL, NULL, '2026-04-03 14:29:00', '2026-04-03 14:29:00', NULL),
(172, 'Wind Hand Sanitizer 500ml (Cybele Cosmetics Ltd)', NULL, NULL, NULL, NULL, '5285002322854', 2, 16, 0, NULL, NULL, '2026-04-03 14:31:21', '2026-04-03 15:01:12', NULL),
(173, 'Ayrtons Touch & Go Toothache Solution 7ml(Ayrtons)', 'Ayrtons', '7ml', NULL, 'Ayrtons Saunders Ltd', 'AYRTONS7ML', 2, 18, 0, NULL, NULL, '2026-04-03 14:34:02', '2026-04-12 16:07:21', NULL),
(174, 'Tavanic Levofloxacine 500mg 5tabs Sanofi', NULL, '500mg', 'tablet', 'Sanofi', '3582910080725', 2, 8, 0, NULL, NULL, '2026-04-03 14:34:03', '2026-04-03 14:34:03', NULL),
(175, 'Gaviscon Double Action Liquid 150ml', NULL, NULL, NULL, 'Reckitt Benckiser', '6009695933901', 2, 7, 0, NULL, NULL, '2026-04-03 14:37:41', '2026-04-03 14:37:41', NULL),
(176, 'Perilon 5mg Prenisolone 10x10Tabs(Phamatex Nig. Ltd)', 'Prednisolone', '5mg', NULL, 'Phamatex Nig. Ltd)', 'UPER08', 2, 6, 0, NULL, NULL, '2026-04-03 14:38:24', '2026-04-03 14:38:24', NULL),
(177, 'Vermox 500mg x1 Oral Tabs(Janssen)', NULL, '500mg', NULL, 'Janssen', 'VERMOX500', 2, 15, 0, NULL, NULL, '2026-04-03 14:41:24', '2026-04-12 16:57:13', NULL),
(178, 'ErythroKid Erythromycin 250mg/5ml 100ml Fidson', NULL, '250mg', 'syrup', 'Fidson', '6034000140576', 2, 8, 0, NULL, NULL, '2026-04-03 14:41:31', '2026-04-03 14:41:31', NULL),
(179, 'Gascol Antacid Suspension 150ml Fidson Blue', NULL, NULL, 'syrup', 'Fidson', '6034000140767', 2, 8, 0, NULL, NULL, '2026-04-03 14:44:37', '2026-04-03 14:44:37', NULL),
(180, 'Wind Hand Sanitizers 100ml(Cybele Cosmetics Ltd)', NULL, '100ml', NULL, 'Cybele Cosmetics Ltd', '5285002322861', 2, 16, 0, NULL, NULL, '2026-04-03 14:46:07', '2026-04-03 15:01:34', NULL),
(181, 'Moxie Vitamin C 100mg/5ml For Children 100ml', NULL, NULL, 'syrup', NULL, '608887022155', 2, 12, 0, NULL, NULL, '2026-04-03 14:47:29', '2026-04-03 14:47:29', NULL),
(182, 'Reload 4 Kidz Multivitamin Syrup 237ml', NULL, NULL, 'syrup', NULL, '615225000362', 2, 12, 0, NULL, NULL, '2026-04-03 14:50:02', '2026-04-03 14:50:02', NULL),
(183, 'Samsu Oil(PD Samsu Indonesia)', 'Samsu', NULL, NULL, 'PD Samsu', 'SAMSUOIL', 2, 17, 0, NULL, NULL, '2026-04-03 14:50:50', '2026-04-12 16:53:28', NULL),
(184, 'Em-Vit-C Vitamin C Syrup Emzor 100ml', NULL, NULL, 'syrup', 'Emzor Pharma', '6154000033354', 2, 12, 0, NULL, NULL, '2026-04-03 14:53:45', '2026-04-03 14:53:45', NULL),
(185, 'Vitapro 500mg Ciprofloxacin 1x10Tabs(Sagar Vitaceutical Nig. Ltd)', 'Ciprofloxacin', '500mg', NULL, 'Sagar vitaceuticals Nig. Ltd', '6154000136093', 2, 8, 0, NULL, NULL, '2026-04-03 14:54:38', '2026-04-03 14:54:38', NULL),
(186, 'Ranferon-12 Tonic 200ml(Ranbaxy Nig. Ltd/Sun Pharma)', 'Blood Builder', '200ml', NULL, 'Ranbaxy/Sun Pharmaceu. Ltd', 'RANFERON200', 2, 9, 0, NULL, NULL, '2026-04-03 15:01:32', '2026-04-12 16:51:44', NULL),
(187, 'Jolax Lactulose Solution 10g/15ml 100ml', NULL, NULL, 'syrup', 'Jawa', '6154000072070', 2, 7, 0, NULL, NULL, '2026-04-03 15:04:25', '2026-04-03 15:04:25', NULL),
(188, 'Relcer Gel 180ml(Glenmark Pharma Ltd)', 'Antacid', '180ml', NULL, 'Glenmark Pharma Ltd', '8904091117703', 2, 7, 0, NULL, NULL, '2026-04-03 15:05:55', '2026-04-03 15:05:55', NULL),
(189, 'Ciprofloxacin 500mg 10 Film Coated tabs Fidson', NULL, '500mg', 'tablet', 'Fidson', '6154000077358', 2, 8, 0, NULL, NULL, '2026-04-03 15:07:04', '2026-04-03 15:10:55', NULL),
(190, 'Rulox Suspension 100ml(SKG Pharma)', 'Antacid', '100ml', NULL, 'SKG Pharma', '608887011371', 2, 7, 0, NULL, NULL, '2026-04-03 15:09:13', '2026-04-03 15:09:13', NULL),
(191, 'Swipha Azithromycin 200mg/5ml 15ml(Swipha)', 'Azithromycin', '15ml', NULL, 'Swipha', 'SWIPHA200MG', 2, 8, 0, NULL, NULL, '2026-04-03 15:12:36', '2026-04-12 17:00:11', NULL),
(192, 'Prednisolone 5mg 10 x 10 tabs Fidson /Card', NULL, '5mg', 'tablet', 'Fidson', NULL, 2, 6, 0, NULL, NULL, '2026-04-03 15:14:43', '2026-04-03 15:14:43', NULL),
(193, 'Tabasil Terbinafine Hcl Cream 15g(Digital Healthcare Ltd)', 'Terbinafine', '15g', NULL, 'Digital Healthcare Ltd', '8902502107046', 2, 6, 0, NULL, NULL, '2026-04-03 15:15:54', '2026-04-03 15:15:54', NULL),
(194, 'Stridox Doxycycline 10x10Caps (Sagar Vitaceuticals) /Card', NULL, '100mg', 'capsule', NULL, '6154000136321', 2, 8, 0, NULL, NULL, '2026-04-03 15:18:58', '2026-04-03 15:18:58', NULL),
(195, 'Sporidex 500mg Cefalexin x10Caps(Sun Pharma/Ranbaxy Nig. Ltd)', 'Cefalexin', '500mg', NULL, 'Sun Pharma/Ranbaxy Nig. Ltd', '8901296110867', 2, 8, 0, NULL, NULL, '2026-04-03 15:19:28', '2026-04-03 15:19:28', NULL),
(196, 'Rulox Suspension 200ml(SKG Pharma)', 'Antacid', '200ml', NULL, 'SKG Pharma', '608887011364', 2, 7, 0, NULL, NULL, '2026-04-03 15:23:20', '2026-04-03 15:23:20', NULL),
(197, 'Moko Methylated Spirit (Alcohol) 200ml (NHW)', NULL, NULL, NULL, 'New Healthway Co. Limited', '6156000058719', 2, 16, 0, NULL, NULL, '2026-04-03 15:24:22', '2026-04-03 15:24:22', NULL),
(198, 'Refucil Griseofulvin Oral Suspension 100ml(Reals Pharma Ltd)', NULL, '100ml', NULL, 'Reals Pharma Ltd', '6156000300429', 2, 4, 0, NULL, NULL, '2026-04-03 15:26:57', '2026-04-03 15:26:57', NULL),
(199, 'Moko Benzyl Benzoate Lotion 100ml (NHW)', NULL, NULL, NULL, 'New Healthway Co. Limited', '6156000058856', 2, 15, 0, NULL, NULL, '2026-04-03 15:31:44', '2026-04-03 15:31:44', NULL),
(200, 'Reprofen Suspension 100mg/5ml(Ibuprofen)100ml(Reals Pharma Ltd)', 'Ibuprofen', '100ml', NULL, 'Reals Pharma Ltd', 'REPROFEN100', 2, 10, 0, NULL, NULL, '2026-04-03 15:33:03', '2026-04-12 16:52:55', NULL),
(201, 'Ranferon-12 Blood Tonic 100ml(Sun Pharma/Ranbaxy Nig. Ltd)', 'Blood Builder', '100ml', NULL, 'Sun Pharma/Ranbaxy Nig. Ltd', 'RANFERON100ML', 2, 9, 0, NULL, NULL, '2026-04-03 15:36:14', '2026-04-12 16:51:14', NULL),
(202, 'Chlorxy-G Gel Chlorhexidine Digluconate  25g (DGF)', NULL, NULL, 'ointment', 'Drugfield', '6156000127613', 2, 16, 0, NULL, NULL, '2026-04-03 15:37:25', '2026-04-03 15:37:25', NULL),
(203, 'Pyrantrim Oral Suspension 15ml(Neimeth Internal. Pharma Ltd)', 'Pyrantrim', '15ml', NULL, 'Neimeth Internal Pharma Ltd', '6156000052373', 2, 15, 0, NULL, NULL, '2026-04-03 15:40:58', '2026-04-03 15:40:58', NULL),
(204, 'Bisacure Bisacodyl 5mg 15x7 tabs (Unicure Pharma) /Card', NULL, '5mg', 'tablet', 'Unicure Pharma', '6156000152844', 2, 7, 0, NULL, NULL, '2026-04-03 15:41:35', '2026-04-03 15:41:35', NULL),
(205, 'Tadalis-5 Tadalafil 5mg 2x14 tabs (Evans Therapeutics Ltd) /Card', NULL, '5mg', 'tablet', 'Bharat Parenterals Ltd', '0721688459781', 2, 17, 0, NULL, NULL, '2026-04-03 15:46:08', '2026-04-03 15:48:59', NULL),
(206, 'Rapidflox 500mg Ciprofloxacin 2x7Tabs(Evans Therapeutic Ltd)', 'Ciprofloxacin', '500mg', NULL, 'Evans Therapeu. Ltd', '8906036360588', 2, 8, 0, NULL, NULL, '2026-04-03 15:46:15', '2026-04-03 15:46:15', NULL),
(207, 'Salmycin 250mg Tetracyclin 10x10Caps(Sagar Vitaceuticals Nig. Ltd)', 'Tetracyclin', '250mg', NULL, 'Sagar Vitaceuti. Nig. Ltd', '6154000136116', 2, 8, 0, NULL, NULL, '2026-04-03 15:50:07', '2026-04-03 15:50:07', NULL),
(208, 'Avicef Ceftriaxone Sodium 1g I.V. Injection (Furen Pharma )', NULL, '1000mg', 'injection', NULL, '8699541272506', 2, 8, 0, NULL, NULL, '2026-04-03 15:51:28', '2026-04-03 15:51:28', NULL),
(209, 'Scissors Small Size', NULL, NULL, NULL, NULL, 'SCISSOR1', 2, 5, 0, NULL, NULL, '2026-04-03 15:53:13', '2026-04-12 16:54:12', NULL),
(210, 'Astymin Amino Acids & Multivitamin Syrup  200ml (Fidson)', NULL, NULL, 'syrup', 'Fidson Healthcare Plc', '8908002671032', 2, 12, 0, NULL, NULL, '2026-04-03 15:54:42', '2026-04-03 15:54:42', NULL),
(211, 'Doxycap 100mg Doxycycline 10x10Caps(Hovid)', 'Doxycycline', '100mg', NULL, 'Hovid', 'UDOX26', 2, 8, 0, NULL, NULL, '2026-04-03 15:56:18', '2026-04-03 15:56:18', NULL),
(212, 'V-Tab 2mg Salbutamol 10x10Tabs(Rock Pharma Ltd)', 'Salbutamol', '2mg', NULL, 'Rock Pharma Ltd', 'SALBU2MG', 2, 6, 0, NULL, NULL, '2026-04-03 16:00:05', '2026-04-12 16:58:14', NULL),
(213, 'Astyfer Iron, Amino Acids & Vitamin Syrup 200ml (Fidson)', NULL, NULL, 'syrup', 'Fidson Healthcare Plc', '8908002671131', 2, 9, 0, NULL, NULL, '2026-04-03 16:03:19', '2026-04-03 16:03:19', NULL),
(214, 'Wormout 200mg Albendazole Chewable 1x2Tabs(Phamatex)', 'Albendazole', '200mg', NULL, 'Pharmatex', '6152110057420', 2, 15, 0, NULL, NULL, '2026-04-03 16:03:47', '2026-04-03 16:03:47', NULL),
(215, 'Wosan Povidone-Iodine Solution 10% 100ml(Jawa)', 'Povidone', '100ml', NULL, 'Jawa', 'WOSAN10', 2, 5, 0, NULL, NULL, '2026-04-03 16:07:26', '2026-04-12 16:56:22', NULL),
(216, 'Sectab Secnidazole-500mg 4tabs (DHL)', NULL, NULL, 'tablet', 'Digitall Healthcare Ltd', '8902502106711', 2, 8, 0, NULL, NULL, '2026-04-03 16:07:46', '2026-04-03 16:07:46', NULL),
(217, 'Cefdoxim Cefpodoxime Proxetil 200mg 10tabs (DHL)', NULL, '200mg', 'tablet', 'Digitall Healthcare Ltd', '8902502106766', 2, 8, 0, NULL, NULL, '2026-04-03 16:11:14', '2026-04-03 16:11:14', NULL),
(218, 'Xasten 0.5mg Dexamethasone 10x10Tabs(Vixa Pharma Co.Ltd)', 'Dexamethasone', '0.5mg', NULL, 'Vixa Pharma Co. Ltd', '6915077807169', 2, 6, 0, NULL, NULL, '2026-04-03 16:11:46', '2026-04-03 16:11:46', NULL),
(219, 'Tabasil Terbinafine 250mg 2x7tabs (Digital Healthcare Ltd)', NULL, '250mg', 'tablet', 'Digitall Healthcare Ltd', '8902502113955', 2, 4, 0, NULL, NULL, '2026-04-03 16:14:29', '2026-04-04 11:38:27', NULL),
(220, 'Zotrim 480mg Co-Trimoxazole 10x10Tabs(Fidson)', 'Co-trimoxazole', '480mg', NULL, 'Fidson', '6034000140750', 2, 8, 0, NULL, NULL, '2026-04-03 16:14:55', '2026-04-03 16:14:55', NULL),
(221, 'Cefdoxim Cefpodoxime Proxetil 40mg Suspension  100ml (DHL)', NULL, '40mg', 'syrup', 'Digitall Healthcare Ltd', '8902502114433', 2, 8, 0, NULL, NULL, '2026-04-03 16:22:03', '2026-04-03 16:22:03', NULL),
(222, 'Vit-A Emulsion (Orange Flavour)100ml(CamPharm Product Ltd)', 'Vitamins', '100ml', NULL, 'CamPharm Product Ltd', 'HTTP://SCN.BY/9T9AB0HTW8JE3E', 2, 12, 0, NULL, NULL, '2026-04-03 16:22:44', '2026-04-03 16:22:44', NULL),
(223, 'Zentel Oral Suspension 20ml(GSK/Panacea Biotec Pharma Ltd)', 'Zentel', '20ml', NULL, 'GSK', '8905091544018', 2, 15, 0, NULL, NULL, '2026-04-03 16:25:59', '2026-04-03 16:25:59', NULL),
(224, 'Calcimax Calcium Mag Zinc & Vit. D3 5x6tabs (Meyer Organics) /Card', NULL, NULL, 'tablet', 'Meyer Organics PVT Ltd', '8904008410620', 2, 12, 0, NULL, NULL, '2026-04-03 16:26:05', '2026-04-03 16:26:05', NULL),
(225, 'Zentel Albendazole 200mg x2Tabs(GSK/Medreich Ltd)', 'Albendazole', '200mg', NULL, 'GSK/Medreich Ltd', 'ZENTEL200MG', 2, 15, 0, NULL, NULL, '2026-04-03 16:30:46', '2026-04-12 16:55:13', NULL),
(226, 'Zetro 500mg Azithromycin x3Tabs(Getz Pharma)', 'Azithromycin', '500mg', NULL, 'Getz Pharma', 'ZETRO500', 2, 8, 0, NULL, NULL, '2026-04-03 16:35:18', '2026-04-12 16:55:54', NULL),
(227, 'Zetro 250mg Azithromycin x10Tabs(Getz Pharma)', 'Azithromycin', '250mg', NULL, 'Getz Pharma', 'ZETRO250MG', 2, 8, 0, NULL, NULL, '2026-04-03 16:38:31', '2026-04-12 16:55:35', NULL),
(228, 'Chromic Catgut Size 2 1/2 45mm 12pcs (LFS) /one', NULL, NULL, NULL, 'Lifesigne Healthcare Ltd', 'CHROMIC-CATGUT', 2, 5, 0, NULL, NULL, '2026-04-04 11:46:37', '2026-04-04 11:46:37', NULL),
(229, 'Ciprotab Ciprofloxacin 500mg x14 soflets (Fidson Healthcare Plc)', NULL, '500mg', 'tablet', 'V.S International Pvt. Ltd', '8906001825265', 2, 8, 0, NULL, NULL, '2026-04-04 11:56:16', '2026-04-04 12:01:33', NULL),
(230, 'Labohydro Hydrocortisone Inj x10Ampul(Embassy Pharma & Chemic. Ltd)', 'Hydrocortisone', '100mg', NULL, 'Embassy Pharma. & Chemic. Ltd)', '8906045943093', 2, 6, 0, NULL, NULL, '2026-04-04 12:04:21', '2026-04-04 12:04:21', NULL),
(231, 'Cimetidine 200mg x20Tabs(Me Cure Industry Plc)', 'Cimetidine', '200mg', NULL, 'Me Cure Industry Plc', 'MECURE200MG', 2, 7, 0, NULL, NULL, '2026-04-04 12:12:29', '2026-04-12 16:12:20', NULL),
(232, 'Citramin Vitamin C Syrup 100mg/5ml 100ml (Afrab-Chem Ltd)', NULL, '100mg', 'syrup', 'Afrab-Chem Ltd', '6154000240783', 2, 12, 0, NULL, NULL, '2026-04-04 12:15:38', '2026-04-04 12:15:38', NULL),
(233, 'Metrone 400mg Metronidazole 10x10Tabs(Fidson)', 'Metronidazole', '400mg', NULL, 'Fidson', '6154000077396', 2, 8, 0, NULL, NULL, '2026-04-04 12:16:46', '2026-04-04 12:18:36', NULL),
(234, 'Claritek Clarithromycin 250mg 10tabs (Getz Pharma)', NULL, '250mg', 'tablet', 'Getz Pharma Pvt. Ltd', 'CLARITEK-250MG', 2, 8, 0, NULL, NULL, '2026-04-04 12:19:39', '2026-04-04 12:19:39', NULL),
(235, 'Metrotab 400mg Metronidazole 10x10Tabs(SKG Pharma)', 'Metronidazole', '400mg', NULL, 'SKG Pharma', '608887011296', 2, 8, 0, NULL, NULL, '2026-04-04 12:22:54', '2026-04-04 12:22:54', NULL),
(236, 'Claritek Clarithromycin 500mg 10tabs (Getz Pharma)', NULL, '500mg', 'tablet', 'Getz Pharma Pvt. Ltd', 'CLARITEK-500MG', 2, 1, 0, NULL, NULL, '2026-04-04 12:23:13', '2026-04-04 12:23:13', NULL),
(237, 'Monamox 500mg Amoxicillin 10x10Caps(Dony-Triumph/Medico Remedies Ltd)', 'Amoxicillin', '500mg', NULL, 'Dony-Triph/Medico Remedies Ltd', '8904181401972', 2, 8, 0, NULL, NULL, '2026-04-04 12:28:45', '2026-04-04 12:28:45', NULL),
(238, 'Climpiclox Ampicillin 250mg & Cloxacillin 250mg 10x10Caps (Maxheal) /Card', NULL, '500mg', 'capsule', 'Maxheal Pharma Ltd', '8904185502903', 2, 8, 0, NULL, NULL, '2026-04-04 12:34:00', '2026-04-04 12:34:00', NULL),
(239, 'Mycoten Clotrimazole Vaginal Cream 35g(DrugField)', 'Clotrimazole', '35g', NULL, 'DrugField', '6156000081366', 2, 4, 0, NULL, NULL, '2026-04-04 12:35:03', '2026-04-04 12:35:03', NULL),
(240, 'Colipan Hyoscine-N-Butylbromide 5mg/5ml 60ml (Sygen)', NULL, '5mg', 'syrup', 'Sygen Pharma Ltd', '6156000067643', 2, 10, 0, NULL, NULL, '2026-04-04 12:38:13', '2026-04-04 12:38:13', NULL),
(241, 'Topcare Nylon Monofilament Size 2(3/8 35mm) x12Pcs(Lifecare Medical Ltd)', 'Monofilament', '35mm', NULL, 'Lifecare Medicals Ltd', NULL, 2, 5, 0, NULL, NULL, '2026-04-04 12:41:42', '2026-04-04 12:41:42', NULL),
(242, 'Elastic Crepe Bandage 15cm x 4.5m (6 Inch) SNWI', NULL, NULL, 'other', NULL, 'BANDAGE-SNWI15CM', 2, 5, 0, NULL, NULL, '2026-04-04 12:45:53', '2026-04-04 12:48:05', NULL),
(243, 'Ornilox 1x10Tabs(Micro Lab)', NULL, NULL, NULL, 'Micro Lab', 'ORNILOX10', 2, 8, 0, NULL, NULL, '2026-04-04 12:48:43', '2026-04-12 16:47:28', NULL),
(244, 'Calcimax Calcium Suspension 100ml (Dr. Meyer\'s) adler', NULL, NULL, 'syrup', 'Vitabiotics (NIG) Ltd', 'CALCIMAX-SYRUP', 2, 12, 0, NULL, NULL, '2026-04-04 12:51:33', '2026-04-04 12:51:33', NULL),
(245, 'Oflomed 200mg Ofloxacin 2x7Tabs(Evans Therapautics Ltd)', 'Ofloxacin', NULL, NULL, 'Evans Therapautics Ltd', 'OFLOMED200MG', 2, 8, 0, NULL, NULL, '2026-04-04 12:52:40', '2026-04-12 16:46:41', NULL),
(246, 'Dr. Meyer\'s Pilex Diosmin 150mg 2x10Tabs(Farmex Meyer Ltd) /Card', 'Diosmin', '150mg', NULL, 'Farmex Meyer Ltd', '6154000273330', 2, 6, 0, NULL, NULL, '2026-04-04 12:57:35', '2026-04-12 09:08:23', NULL),
(247, 'Cypri Gold Syrup Cyproheptadine & Amino acid 200ml', NULL, NULL, 'syrup', 'Therapeutic Laboratories (NIG) Ltd', '6156000294438', 2, 9, 0, NULL, NULL, '2026-04-04 13:00:07', '2026-04-04 13:02:59', NULL),
(248, 'Cypri Gold Syrup Cyproheptadine & Amino acid 100ml', NULL, NULL, 'syrup', 'Therapeutic Laboratories (Nig.) Ltd.', '6156000294421', 2, 9, 0, NULL, NULL, '2026-04-04 13:04:45', '2026-04-04 13:04:45', NULL),
(249, 'Ocefix 400mg Cefixime 1x10Tabs (Swipha)', 'Cefixime', '400mg', NULL, 'Swipha', '8906035499210', 2, 8, 0, NULL, NULL, '2026-04-04 13:06:43', '2026-04-04 13:06:43', NULL),
(250, 'Dalacap-150 Clindamycin 10 Caps 150mg (Transglobe Pharma)', NULL, '150mg', 'capsule', 'Transglobe Pharma Co. Ltd.', 'DALACAP-150', 2, 8, 0, NULL, NULL, '2026-04-04 13:10:19', '2026-04-04 13:10:19', NULL),
(251, 'Piriton 4mg Chlorpheniramine Maleate 25x10Tabs *Per Card(Evans Baroque Ltd)', 'Chlorpheniramine', '4mg', NULL, 'Evans Baroque Ltd', '6153400151873', 2, 6, 0, NULL, NULL, '2026-04-04 13:13:37', '2026-04-17 12:56:43', NULL),
(252, 'Dalacap-300 Clindamycin 10 Caps 300mg (Transglobe Pharma)', NULL, '300mg', 'capsule', 'Transglobe Pharma Co. Ltd.', 'DALACAP-300', 2, 8, 0, NULL, NULL, '2026-04-04 13:14:16', '2026-04-04 13:14:16', NULL),
(253, 'Primpex DS x10Tabs(SKG Pharma)', 'Clotrimazole', '960mg', NULL, 'SKG Pharma', '608887011258', 2, 8, 0, NULL, NULL, '2026-04-04 13:17:37', '2026-04-04 13:17:37', NULL),
(254, 'Danacid Suspension Antacid & Antiflatulent 200ml (Dana)', NULL, NULL, 'syrup', 'Dana Pharma Ltd.', '6154000040383', 2, 7, 0, NULL, NULL, '2026-04-04 13:18:11', '2026-04-04 13:18:11', NULL),
(255, 'Deleject 22G Disposable Needles 1x100(HMA Medical Ltd', 'Needle', NULL, NULL, 'HMA Medical Ltd', 'DELEJECT-22G', 2, 5, 0, NULL, NULL, '2026-04-04 13:21:24', '2026-04-04 13:24:40', NULL),
(256, 'Deleject Syring and Needle 2ml Sterile EO', NULL, NULL, 'injection', 'HMA Medical Ltd.', 'DELEJECT-2ML', 2, 5, 0, NULL, NULL, '2026-04-04 13:22:31', '2026-04-04 13:22:31', NULL),
(257, 'Pezol Metroclopramide Injec. x10Ampuls(Hubei Tianyo Pharma Co.Ltd)', 'Metoclopramide', '10mg/2ml', NULL, '(Hubei Tianyo Pharma Co.Ltd', 'PEZOL-10', 2, 7, 0, NULL, NULL, '2026-04-04 13:26:04', '2026-04-12 16:49:06', NULL),
(258, 'Deleject Syring and Needle 5ml Sterile EO', NULL, NULL, 'injection', 'HMA Medical Ltd.', 'DELEJECT-5ML', 2, 5, 0, NULL, NULL, '2026-04-04 13:26:49', '2026-04-04 13:26:49', NULL),
(259, 'Laifen 10mg Chlorpheniramine Maleate Inj. x10Ampuls(Chupet )', 'Chlorpheniramine', '10mg/1ml', NULL, 'Chupet Pharm Co. Ltd', 'CHUPET10MG', 2, 6, 0, NULL, NULL, '2026-04-04 13:31:14', '2026-04-12 16:41:31', NULL),
(260, 'Paracetamol Inject x10ampul(MultiChris Pharma & Chemical Co. Ltd)', 'Paracetamol', '150mg', NULL, 'MultiChris Pharma & Chemical Co. Ltd', 'MULTICHRIS', 2, 10, 0, NULL, NULL, '2026-04-04 13:38:02', '2026-04-12 16:48:28', NULL),
(261, 'Dequadin Lozenges 250mcg 100tabs (x25 sachets) Evans /Card', NULL, '250mcg', 'tablet', 'Evans Baroque', '6156000371856', 2, 11, 0, NULL, NULL, '2026-04-04 13:39:17', '2026-04-04 13:39:17', NULL),
(262, 'Plaster White 2Inch', 'Plaster', NULL, NULL, NULL, 'PLASTER40', 2, 5, 0, NULL, NULL, '2026-04-04 13:40:42', '2026-04-12 16:50:34', NULL),
(263, 'Plaster Grey Color 5cmx5m', 'Plaster', NULL, NULL, NULL, 'PLASTER5CM', 2, 5, 0, NULL, NULL, '2026-04-04 13:43:23', '2026-04-12 16:49:43', NULL),
(264, 'Plaster Grey Color Small Size', 'Plaster', NULL, NULL, NULL, 'PLASTER09', 2, 5, 0, NULL, NULL, '2026-04-04 13:45:37', '2026-04-12 16:50:10', NULL),
(265, 'Ocefix Cefixime 100mg/5ml Oral Suspen. 60ml(Swipha)', 'Cefixime', '100mg/5ml', NULL, 'Swipha', '8906035499227', 2, 8, 0, NULL, NULL, '2026-04-04 13:49:05', '2026-04-04 13:49:05', NULL),
(266, 'Ocefix Cefixime 100mg/5ml Oral Suspen. 100ml(Swipha)', 'Cefixime', '100mg/5ml', NULL, 'Swipha', '8906035499234', 2, 8, 0, NULL, NULL, '2026-04-04 13:51:16', '2026-04-04 13:51:16', NULL),
(267, 'Nitrofurantoin 100mg 10tabs (De-Shalom Pharma)', NULL, '100mg', 'tablet', 'De-Shalom Pharm', 'DE-SHALOM-100MG', 2, 8, 0, NULL, NULL, '2026-04-04 13:54:59', '2026-04-04 13:54:59', NULL),
(268, 'Nugel-O Suspen. Antacid 200ml(Assene-;Laborex Ltd', 'Antacid', '200ml', NULL, 'Assene-Laborex Ltd', 'NUGEL-O-200ML', 2, 7, 0, NULL, NULL, '2026-04-04 13:57:03', '2026-04-12 08:31:26', NULL),
(269, 'MIM Multivitamins & Iron Mineral Syrup 300ml', 'Blood Builder', '300ml', NULL, 'Alder Product Ltd', 'MIM300ML', 2, 9, 0, NULL, NULL, '2026-04-04 14:00:36', '2026-04-12 16:45:05', NULL),
(270, 'Nospamin Syrup 60ml (Afrabs)', 'Nospamin', '60ml', NULL, 'Afrabs', '6154000240240', 2, 7, 0, NULL, NULL, '2026-04-04 14:04:03', '2026-04-04 14:04:03', NULL),
(271, 'Den-V 100 Disposable Gloves (Seward)', NULL, NULL, NULL, NULL, 'DEN-V100', 2, 5, 0, NULL, NULL, '2026-04-04 14:06:47', '2026-04-04 14:06:47', NULL),
(272, 'Magsil Antacid Suspen. 200ml(Daily Sun Pharma Comp. Ltd)', 'Antacid', '200ml', NULL, 'Daily Sun Pharma Comp. Ltd', 'MAGSIL200ML', 2, 7, 0, NULL, NULL, '2026-04-04 14:11:05', '2026-04-12 16:43:22', NULL),
(273, 'Diclofenac Sodium Injection 75mg/3ml (Embassy) /Ampoule', NULL, '75mg', 'injection', 'Embassy Pharma & Chemicals Ltd.', '08906045942027', 2, 10, 0, NULL, NULL, '2026-04-04 14:13:09', '2026-04-04 14:13:09', NULL);
INSERT INTO `drugs` (`id`, `brand_name`, `generic_name`, `strength`, `dosage_form`, `manufacturer`, `barcode`, `category_id`, `subcategory_id`, `is_prescription_only`, `controlled_substance_class`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(274, 'Moko Mist.Mag Trisilicate Antacid Suspen. 200ml(New Healthway Co. Ltd)', 'Antacid', NULL, NULL, 'New Healthway Co. Ltd', '6156000058726', 2, 7, 0, NULL, NULL, '2026-04-04 14:15:12', '2026-04-04 14:15:12', NULL),
(275, 'Mist.Pot.Cit 200ml(Jesil Pharma. Ind. Ltd)', 'Antacid', NULL, NULL, 'Jesil Pharma. Ind. Ltd', 'JESIL-200ML', 2, 7, 0, NULL, NULL, '2026-04-04 14:18:29', '2026-04-11 16:28:41', NULL),
(276, 'EMAL Arteether Injection 150ml/2ml 3x2ml (Fidson)', NULL, '150mg', 'injection', 'Fidson Healthcare Plc', 'E-MAL-150MG', 2, 20, 0, NULL, NULL, '2026-04-04 14:19:32', '2026-04-18 14:57:18', NULL),
(277, 'Mamacod Cod Liver Oil 170ml(Influx Healthtech Ltd)', 'Cod Liver', '170ml', NULL, 'Influx Healthtech Ltd', 'MAMACOD170ML', 2, 12, 0, NULL, NULL, '2026-04-04 14:22:28', '2026-04-12 16:43:52', NULL),
(278, 'Finger Strip Plasters 80 Fabric Adhesive (SWA-LIFE) /Strip', NULL, NULL, NULL, 'Swa-Life Resources Ltd', 'SWA-LIFE80', 2, 5, 0, NULL, NULL, '2026-04-04 14:24:46', '2026-04-04 14:24:46', NULL),
(279, 'Em-Vit-C Chewable Vitamin C 1000tabs Emzor /Tab', NULL, '100mg', 'tablet', 'Emzor Pharma Industries Ltd.', '6154000033439', 2, 12, 0, NULL, NULL, '2026-04-04 14:30:37', '2026-04-04 14:30:37', NULL),
(280, 'Multivite Multivitamin Syrup 100ml(Evans Baroque Ltd)', 'Vitamin', '100ml', NULL, 'Evans Baroque Ltd', '6156000371849', 2, 12, 0, NULL, NULL, '2026-04-04 14:33:50', '2026-04-04 14:33:50', NULL),
(281, 'Face Mask Disposable Non-Woven 3-Ply Ear Loop 50pcs (Blue)', NULL, NULL, 'other', 'Hubei Medwear Protective Products Co., Ltd.', '6281114911060', 2, 5, 0, NULL, NULL, '2026-04-04 14:36:29', '2026-04-04 14:36:29', NULL),
(282, 'Loxagyl Metronidazole Syrup 60ml(M&B)', 'Metronidazole', '60ml', NULL, 'M&B', '6151006000168', 2, 8, 0, NULL, NULL, '2026-04-04 14:38:16', '2026-04-04 14:38:16', NULL),
(283, 'Emgyl Metronidazole BP 200mg 10x10tabs (Emzor) /Card', NULL, '200mg', 'tablet', 'Emzor Pharma Industries Ltd.', '6154000034436', 2, 8, 0, NULL, NULL, '2026-04-04 14:47:10', '2026-04-04 14:47:10', NULL),
(284, 'Emgyl Suspension Metronidazole 200mg/5ml 60ml (Emzor)', NULL, '200mg', 'syrup', 'Emzor Pharma Industries Ltd', '6154000034368', 2, 8, 0, NULL, NULL, '2026-04-04 14:51:31', '2026-04-04 14:51:31', NULL),
(285, 'Lyntriaxone Ceftriaxone 1g I.M & I.V Injection(Lyn-Edge )', 'Ceftriaxone', '1g', NULL, 'Lyn-Edge Phrama Ltd', 'LYNTRIA1G', 2, 8, 0, NULL, NULL, '2026-04-04 14:53:57', '2026-04-12 16:42:55', NULL),
(286, 'Emtrim Suspension Co-trimoxazole 240mg/5ml 50ml (Emzor)', NULL, '240mg', 'syrup', 'Emzor Pharma. Industries Ltd', '6154000034405', 2, 8, 0, NULL, NULL, '2026-04-04 14:55:00', '2026-04-04 14:55:00', NULL),
(287, 'Emvite Multivitamin Syrup 100ml (Emzor)', NULL, NULL, 'syrup', 'Emzor Pharma. Industries Ltd', '6154000033392', 2, 12, 0, NULL, NULL, '2026-04-04 14:58:30', '2026-04-04 14:58:30', NULL),
(288, 'Emzoclox Suspension Ampicillin & Cloxacillin 250mg 100ml (Emzor)', NULL, '250mg', 'syrup', 'Emzor Pharma. industries Ltd', '6154000034375', 2, 8, 0, NULL, NULL, '2026-04-04 15:02:25', '2026-04-04 15:02:25', NULL),
(289, 'Eusol A & B Solution NINO 100ml', NULL, NULL, NULL, 'Nino Pharm & Chem Co. Ltd.', 'NINO-EUSOL-PINK', 2, 5, 0, NULL, NULL, '2026-04-04 15:05:44', '2026-04-04 15:05:44', NULL),
(290, 'Esoma Methylated Spirit B.P. 2 Litres', NULL, NULL, NULL, 'Esoma Pharma Ltd.', 'ESOMA-2LITRES', 2, 5, 0, NULL, NULL, '2026-04-04 15:08:56', '2026-04-04 15:08:56', NULL),
(291, 'Gynaecological Gloves 7.5 Super+Care (SafeShield) /one)', NULL, NULL, NULL, NULL, 'SUPER+CARE', 2, 5, 0, NULL, NULL, '2026-04-04 15:13:07', '2026-04-04 15:13:07', NULL),
(292, 'Clinic Clear Skin Whitening Soap 250g', NULL, NULL, NULL, NULL, '6181100284218', 4, NULL, 0, NULL, NULL, '2026-04-06 11:27:43', '2026-04-06 11:27:43', NULL),
(293, 'Cheese Balls Party Pack Fun Snax 90g', NULL, NULL, NULL, 'Sunlight Resouces Ltd.', '6154000170004', 4, NULL, 0, NULL, NULL, '2026-04-06 11:30:32', '2026-04-06 11:30:32', NULL),
(294, 'Bio-Oil Whitening Herbal Soap(Papaya) 250g', NULL, '250g', NULL, NULL, '3760125501017', 4, NULL, 0, NULL, NULL, '2026-04-06 11:30:38', '2026-04-06 11:30:38', NULL),
(295, 'Beloxxi Cream Crackers', NULL, NULL, NULL, NULL, '6153400011207', 4, NULL, 0, NULL, NULL, '2026-04-06 11:34:42', '2026-04-06 11:34:42', NULL),
(296, 'Hide&Seek Fab! Chocolate Cookies', NULL, NULL, NULL, NULL, '8901719920752', 4, NULL, 0, NULL, NULL, '2026-04-06 11:38:10', '2026-04-06 11:38:10', NULL),
(297, 'Pears Pure ,Mild & Gentle Body Oil 200ml', NULL, NULL, NULL, NULL, '6151100139405', 4, NULL, 0, NULL, NULL, '2026-04-06 11:39:52', '2026-04-06 11:39:52', NULL),
(298, 'Parle Creamy & Buttery ShortBread  Choco Chips', NULL, NULL, NULL, NULL, '8901719926716', 4, NULL, 0, NULL, NULL, '2026-04-06 11:41:06', '2026-04-06 11:41:06', NULL),
(299, 'Munch Kins Crunchy Crispy Delicious Choco Chip Biscuits YALE', NULL, NULL, NULL, NULL, '6154000262310', 4, NULL, 0, NULL, NULL, '2026-04-06 11:44:14', '2026-04-06 11:44:14', NULL),
(300, 'Pears Pure Mild & Gentle Body Lotion 200ml', NULL, NULL, NULL, NULL, '6151100139429', 4, NULL, 0, NULL, NULL, '2026-04-06 11:45:32', '2026-04-06 11:45:32', NULL),
(301, 'Munch It Crunchy Corn Snacks Sweet Surprise', NULL, NULL, NULL, NULL, '6154000101787', 4, NULL, 0, NULL, NULL, '2026-04-06 11:54:21', '2026-04-06 11:54:21', NULL),
(302, 'Estelin AHA Rejuvenate Toner 400ml', NULL, NULL, NULL, NULL, '6971764157658', 4, NULL, 0, NULL, NULL, '2026-04-06 11:57:12', '2026-04-06 11:57:12', NULL),
(303, 'Mamuda Puff Wafers Honey & Milk Flavoured', NULL, NULL, NULL, NULL, '5060909741812', 4, NULL, 0, NULL, NULL, '2026-04-06 11:57:49', '2026-04-06 11:57:49', NULL),
(304, 'Mamuda Puff Wafers Chocolate Flavoured', NULL, NULL, NULL, NULL, '5060909741805', 4, NULL, 0, NULL, NULL, '2026-04-06 12:00:11', '2026-04-06 12:00:11', NULL),
(305, 'Estelin Repair Toner 400ml', NULL, NULL, NULL, NULL, '6971764157641', 4, NULL, 0, NULL, NULL, '2026-04-06 12:00:41', '2026-04-06 12:00:41', NULL),
(306, 'My Dear Kidz Robotic Body Spray 150ml', NULL, NULL, NULL, NULL, '6294015161960', 4, NULL, 0, NULL, NULL, '2026-04-06 12:02:58', '2026-04-06 12:02:58', NULL),
(307, 'Noble Baby Kids Deodorant(Sweet Mouse)Body Spray 150ml', NULL, NULL, NULL, NULL, '4892573027531', 4, NULL, 0, NULL, NULL, '2026-04-06 12:06:34', '2026-04-06 12:06:34', NULL),
(308, 'My Dear Kidz (Teddy Pirate) Body Spray 150ml', NULL, NULL, NULL, NULL, '6294015161915', 4, NULL, 0, NULL, NULL, '2026-04-06 12:08:25', '2026-04-06 12:08:25', NULL),
(309, 'Noble Baby Kids deodorant (Green Men) Body Spray 150ml', NULL, NULL, NULL, NULL, '4892573027517', 4, NULL, 0, NULL, NULL, '2026-04-06 12:09:53', '2026-04-06 12:09:53', NULL),
(310, 'My Dear Kidz (Tasha\'s Tale) Body Spray 150ml', NULL, NULL, NULL, NULL, '6294015161991', 4, NULL, 0, NULL, NULL, '2026-04-06 12:11:35', '2026-04-06 12:11:35', NULL),
(311, 'My Dear Kidz (!Zap)Body Spray 150ml', NULL, NULL, NULL, NULL, '6294015161953', 4, NULL, 0, NULL, NULL, '2026-04-06 12:13:08', '2026-04-06 12:13:08', NULL),
(312, 'Vaseline Cocoa Radiant Body Oil 200ml', NULL, NULL, NULL, NULL, '305210287303', 4, NULL, 0, NULL, NULL, '2026-04-06 12:14:41', '2026-04-06 12:14:41', NULL),
(313, 'NCP Liquid Antiseptic 100ml Neimeth', NULL, NULL, NULL, 'Neimeth International Pharma Plc.', '6156000052359', 2, 16, 0, NULL, NULL, '2026-04-06 12:17:31', '2026-04-06 12:17:31', NULL),
(314, 'Romano Classic Deodorant Roll-On(Classic) 50ml', NULL, NULL, NULL, NULL, '8935212810111', 4, NULL, 0, NULL, NULL, '2026-04-06 12:18:20', '2026-04-06 12:18:20', NULL),
(315, 'Sudrex Extra Pcm, Ibuprofen, caffeine 2x10tabs /Card', NULL, NULL, 'tablet', 'Tempo Scan Africa Ltd', '8999908984500', 2, 10, 0, NULL, NULL, '2026-04-06 12:21:01', '2026-04-06 12:22:24', NULL),
(316, 'Romano Classic Deodorant Roll-On(Attitude) 50ml', NULL, NULL, NULL, NULL, '8935212811026', 4, NULL, 0, NULL, NULL, '2026-04-06 12:21:59', '2026-04-06 12:21:59', NULL),
(317, 'Romano Classic Deodorant Roll-On(VIP) 50ml', NULL, NULL, NULL, NULL, '8935212811842', 4, NULL, 0, NULL, NULL, '2026-04-06 12:23:25', '2026-04-06 12:23:25', NULL),
(318, 'Romano Classic Deodorant Roll-On(CForce) 50ml', NULL, NULL, NULL, NULL, '8935212810845', 4, NULL, 0, NULL, NULL, '2026-04-06 12:25:45', '2026-04-06 12:25:45', NULL),
(319, 'Cosamid Plus Gluco 250mg Chond 200mg 10x10 Caps /Card', NULL, NULL, 'capsule', 'Hovid Bhd', '9556100102775', 2, 12, 0, NULL, NULL, '2026-04-06 12:26:19', '2026-04-06 12:26:19', NULL),
(320, 'Elan Mentholated Shampoo 500ml', NULL, NULL, NULL, NULL, '6156000101033', 4, NULL, 0, NULL, NULL, '2026-04-06 12:27:13', '2026-04-06 12:27:13', NULL),
(321, 'Elan Mentholated Conditioner 500ml', NULL, NULL, NULL, NULL, '6156000101040', 4, NULL, 0, NULL, NULL, '2026-04-06 12:28:33', '2026-04-06 12:28:33', NULL),
(322, 'Storm Perfume Deodorant Body Spray(Amber Oud)', NULL, NULL, NULL, NULL, '8699009466768', 4, NULL, 0, NULL, NULL, '2026-04-06 12:30:38', '2026-04-06 12:30:38', NULL),
(323, 'Storm Elixir Perfume Body Spray(Flood)200ml', NULL, NULL, NULL, NULL, '8699009466720', 4, NULL, 0, NULL, NULL, '2026-04-06 12:34:00', '2026-04-06 12:34:00', NULL),
(324, 'Duphaston 10mg Dydrogestrone 20 tabs (Abbott)', NULL, '10mg', 'tablet', 'Abbott Laboratories', '8002660026576', 2, 21, 0, NULL, NULL, '2026-04-06 12:34:02', '2026-04-06 12:34:02', NULL),
(325, 'Storm Elixir Perfume Body Spray(Gaia)200ml', NULL, NULL, NULL, NULL, '8699009464917', 4, NULL, 0, NULL, NULL, '2026-04-06 12:34:57', '2026-04-06 12:34:57', NULL),
(326, 'Storm Elixir Perfume Body Spray(Flood)200ml', NULL, NULL, NULL, NULL, '8699009466713', 4, NULL, 0, NULL, NULL, '2026-04-06 12:36:01', '2026-04-06 12:36:01', NULL),
(327, 'TCB Natural Hair Food(Anti-Dandruff) 100ml', NULL, NULL, NULL, NULL, '6154000086114', 4, NULL, 0, NULL, NULL, '2026-04-06 12:38:27', '2026-04-06 12:38:27', NULL),
(328, 'TCB Natural Hair Food(Indian Herbs) 100ml', NULL, NULL, NULL, NULL, '6154000086206', 4, NULL, 0, NULL, NULL, '2026-04-06 12:40:12', '2026-04-06 12:40:12', NULL),
(329, 'Tamsulosin-XL Tamsulosin 0.4mg 3x10 Caps Samjones /Card', NULL, '400Mcg', 'capsule', 'Globela Pharma Pvt. Ltd.', '8906045625388', 2, 21, 0, NULL, NULL, '2026-04-06 12:40:45', '2026-04-06 12:40:45', NULL),
(330, 'Hair Fit Darkening Cream 150g', NULL, NULL, NULL, NULL, '6154000403447', 4, NULL, 0, NULL, NULL, '2026-04-06 12:41:58', '2026-04-06 12:41:58', NULL),
(331, '2Black  Darkening Hair Cream 150g', NULL, NULL, NULL, NULL, '714084866390', 4, NULL, 0, NULL, NULL, '2026-04-06 12:43:28', '2026-04-10 12:45:37', NULL),
(332, 'Mega Growth Hair Super Food Anti-dandruff', NULL, NULL, NULL, NULL, '6156000060538', 4, NULL, 0, NULL, NULL, '2026-04-06 12:45:05', '2026-04-06 12:45:05', NULL),
(333, 'Diamet Metformin 500mg 6x14 tabs May & Baker /Card', NULL, '500mg', 'tablet', 'May & baker Nigeria Plc.', '6151006000090', 2, 22, 0, NULL, NULL, '2026-04-06 12:45:26', '2026-04-06 12:45:26', NULL),
(334, 'Aeroline Salbutamol 100ug Inhaler 200 doses', NULL, NULL, 'other', 'Jewim Pharma Co., Ltd.', '6936448800459', 2, 6, 0, NULL, NULL, '2026-04-06 12:58:40', '2026-04-06 12:58:40', NULL),
(335, 'Furosemid 40mg 2x14tabs Crescent Pharma Ltd /Card', NULL, '40mg', 'tablet', 'Crescent Pharma Ltd', '5017123270024', 2, 23, 0, NULL, NULL, '2026-04-06 13:02:44', '2026-04-06 13:02:44', NULL),
(336, 'Furosemid 20mg 2x14tabs Crescent Pharma Ltd /Card', NULL, '20mg', 'tablet', 'Crescent Pharma Ltd', '5017123328022', 2, 23, 0, NULL, NULL, '2026-04-06 13:05:56', '2026-04-06 13:05:56', NULL),
(337, 'Rosudex Rosuvastatine 20mg 3x10 tabs (Zolon) /Card', NULL, '20mg', 'tablet', 'Emzor Pharma Industries Ltd.', '6156000262888', 2, 23, 0, NULL, NULL, '2026-04-06 13:22:25', '2026-04-06 13:22:25', NULL),
(338, 'Bilaxten bilastine 20mg 10tabs (FAES FARMA)', NULL, '20mg', 'tablet', 'Faes Farma', '8436024610437', 2, 6, 0, NULL, NULL, '2026-04-06 13:27:50', '2026-04-06 13:27:50', NULL),
(339, '714084870854', 'Neoskin', '30g', NULL, 'Elbe Pharma Nig. Ltd', '714084870854', 2, 4, 0, NULL, NULL, '2026-04-06 13:33:53', '2026-04-06 13:33:53', NULL),
(340, 'Odizat Amlodipine 10mg + Valsartan 160mg 3x10 tabs Bezik /Card', NULL, NULL, 'tablet', 'Avantika Medex Pvt. Ltd.', '8906140361945', 2, 23, 0, NULL, NULL, '2026-04-06 13:35:00', '2026-04-06 13:36:34', NULL),
(341, 'Real Night Aid 2x15Tabs(Reals Pharma Ltd)', 'Diphenhydramine', '50mg', NULL, 'Reals Pharma Ltd', 'REAL15', 2, 6, 0, NULL, NULL, '2026-04-06 13:37:11', '2026-04-12 16:52:14', NULL),
(342, 'Cet-10 Cetirizine 10mg 10x10 tabs /Card', NULL, '10mg', 'tablet', 'Juhel Nigeria Ltd.', '6156000150550', 2, 6, 0, NULL, NULL, '2026-04-06 13:39:00', '2026-04-06 13:39:00', NULL),
(343, 'Ibuprofen Oral Suspen. For Children 100ml(NHP Generics)', 'Ibuprofen', '100ml', NULL, 'NHP Generics', '11040080', 2, 10, 0, NULL, NULL, '2026-04-06 13:40:58', '2026-04-06 13:40:58', NULL),
(344, 'Prexam Tranexamic Injection x5 Amp/5ml /Ampoule', NULL, '500mg', 'injection', 'Protech Biosystems Pvt. Ltd.', '8901783007960', 2, 10, 0, NULL, NULL, '2026-04-06 13:42:29', '2026-04-06 13:42:29', NULL),
(345, 'Tuxil-D Expectorant (Cough & Cold) Cough Syrup For Adults 100ml(Fidson)', 'Cough Syrup', '100ml', NULL, 'Fidson', '6034000140514', 2, 1, 0, NULL, NULL, '2026-04-06 13:46:00', '2026-04-06 13:46:00', NULL),
(346, 'Aristobet-N Eye, Ear & Nasal Drops 5ml', NULL, NULL, NULL, 'Aristopharma Ltd.', '745125264592', 2, 13, 0, NULL, NULL, '2026-04-06 13:48:38', '2026-04-06 13:48:38', NULL),
(347, 'Amitriptyline 25mg x28Tabs(Teva)', 'Amitriptyline', '25mg', NULL, 'Teva', '5017007111122', 2, 6, 0, NULL, NULL, '2026-04-06 13:50:04', '2026-04-06 13:50:04', NULL),
(348, 'Salacyn Eye Drops Sodium Chloride 10ml', NULL, NULL, NULL, 'Ashford Laboratories Ltd.', '9588800183112', 2, 13, 0, NULL, NULL, '2026-04-06 13:51:49', '2026-04-06 13:51:49', NULL),
(349, 'Beehive Balsam Cough Syrup 200ml(Ayrtons Saunders Ltd)', 'Cough Syrup', '200ml', NULL, 'Ayrtons Saunders Ltd', '5028268050358', 2, 1, 0, NULL, NULL, '2026-04-06 13:55:27', '2026-04-06 13:55:27', NULL),
(350, 'Ascipram Escitalopram 20mg 3x10tabs (Micro Lab) /Card', NULL, '20mg', 'tablet', 'Micro Lab Ltd.', 'ASCIPRAM-20MG', 2, 25, 0, NULL, NULL, '2026-04-06 13:56:50', '2026-04-06 14:08:12', NULL),
(351, 'Robb Original Ointment 23ml(Cusson PZ)', 'Ointment', NULL, NULL, 'Cusson PZ', '6033000102584', 2, 10, 0, NULL, NULL, '2026-04-06 14:07:37', '2026-04-06 14:07:37', NULL),
(352, 'Samjones Clopidogrel 75mg 3x10 tabs Dezubik /Card', NULL, '75mg', 'tablet', 'Globela Pharma Pvt. Ltd.', '8906045625340', 2, 23, 0, NULL, NULL, '2026-04-06 14:14:57', '2026-04-06 14:14:57', NULL),
(353, 'Tuxil-D Expectant Cough,Cold & Allergy(2-12) Syrup 100ml(Fidson)', 'Cough Syrup', '100ml', NULL, 'Fidson', '6034000140842', 2, 11, 0, NULL, NULL, '2026-04-06 14:16:35', '2026-04-06 14:16:35', NULL),
(354, 'Ascipram Escitalopram 10mg 3x10tabs (Micro Lab) /Card', NULL, '10mg', 'tablet', 'Micro Lab Ltd.', 'ASCIPRAM-10MG', 2, 25, 0, NULL, NULL, '2026-04-06 14:18:11', '2026-04-06 14:18:11', NULL),
(355, 'Tuxil-N Expectorant Cough & Cold Syrup For Adult 100ml(Fidson)', 'Cough Syrup', '100ml', NULL, 'Fidson', '6034000140521', 2, 11, 0, NULL, NULL, '2026-04-06 14:21:06', '2026-04-06 14:21:06', NULL),
(356, 'Moxie Paracetamol Syrup 100ml(oak-faith Pharmace. ltd', 'Paracetamol', '100ml', NULL, 'Oak-faith Pharma Ltd', '608887022148', 2, 10, 0, NULL, NULL, '2026-04-06 14:25:11', '2026-04-06 14:25:11', NULL),
(357, 'Bondomet Methyldopa 250mg 10x10tabs (Bond Chemical) /Card', NULL, '250mg', 'tablet', 'Bond Chemical Ind. Ltd.', 'BONDOMET-250MG', 2, 23, 0, NULL, NULL, '2026-04-06 14:25:21', '2026-04-06 14:25:21', NULL),
(358, 'Emzor Paracetamol Drops 15ml(emzor Pharma)', 'Paracetamol', '15ml', NULL, 'Emzor', '6154000033071', 2, 10, 0, NULL, NULL, '2026-04-06 14:27:54', '2026-04-06 14:27:54', NULL),
(359, 'Cenpain Night 2x10Caplets *Per Card Tuyil Pharm', NULL, NULL, 'tablet', 'Tuyil Pharm. Ind. Ltd.', 'CENPAIN-NIGHT20', 2, 25, 0, NULL, NULL, '2026-04-06 14:30:05', '2026-04-17 13:03:27', NULL),
(360, 'Hcort Hydrocortisone Cream 25g(Fidson)', 'Hydrocortisone', '25g', NULL, 'Fidson', '6154000077877', 2, 6, 0, NULL, NULL, '2026-04-06 14:31:05', '2026-04-06 14:31:05', NULL),
(361, 'Contiflo XL Tamsulosin 400mcg 3x10Caps (Sun Pharma) /Card', NULL, '400mcg', 'capsule', 'Sun Pharma UK Ltd.', '5015525030512', 2, 21, 0, NULL, NULL, '2026-04-06 14:34:45', '2026-04-06 14:34:45', NULL),
(362, 'Curefenac 50mg 1x10Tabs(Unicure Pharma Ltd', 'Diclofenac', '50mg', NULL, 'Unicure Pharma. Ltd', '6156000152769', 2, 10, 0, NULL, NULL, '2026-04-06 14:36:41', '2026-04-06 14:36:41', NULL),
(363, 'Mycoten-Plus x7 Vaginal Tablet(DrugField0', NULL, '200mg', NULL, 'GrugField', '6156000158280', 2, 4, 0, NULL, NULL, '2026-04-06 14:40:00', '2026-04-06 14:40:00', NULL),
(364, 'Natrilix SR Indapamide 1.5mg 2x10tabs Servier Paki /Card', NULL, '1.5mg', 'tablet', 'Servier Research & Pharma', 'NATRILIX-SR30', 2, 23, 0, NULL, NULL, '2026-04-06 14:41:42', '2026-04-06 14:41:42', NULL),
(365, 'Neurogesic Extra Ointment 85g(DGF)', 'Ointment', '85g', NULL, 'DGF', '6156000223919', 2, 10, 0, NULL, NULL, '2026-04-06 14:46:08', '2026-04-06 14:46:08', NULL),
(366, 'Chloramphenicol Sterile eye drops 0.5% Drugfield 10ml', NULL, NULL, NULL, 'DrugField Pharma Ltd.', '6156000132594', 2, 13, 0, NULL, NULL, '2026-04-06 14:47:44', '2026-04-06 14:47:44', NULL),
(367, 'Panadol Pain & Fever 10x10Tabs(GSK)', 'Paracetamol', '500mg', NULL, 'GSK', '6161105661993', 2, 10, 0, NULL, NULL, '2026-04-06 14:48:43', '2026-04-06 14:48:43', NULL),
(368, 'Panadol Extra 10x10Tabs(GSK)', 'Paracetamol', '500mg', NULL, 'GSK', '6161105661986', 2, 10, 0, NULL, NULL, '2026-04-06 14:50:53', '2026-04-06 14:50:53', NULL),
(369, 'Gentalab Gentamicin  Eye/Ear Drops 0.3% 10ml (Laborate)', NULL, NULL, NULL, 'Laborate Pharma India', 'GENTALAB-DROPS', 2, 13, 0, NULL, NULL, '2026-04-06 14:53:34', '2026-04-06 14:53:34', NULL),
(370, 'Camosunate Tabs (Junior 7-13Years)(Geneith Pharma Ltd)', NULL, '300mg', NULL, 'Geneith Pharma Ltd', '6928623000082', 2, 20, 0, NULL, NULL, '2026-04-06 14:54:57', '2026-04-06 14:54:57', NULL),
(371, 'Optalyn Olapatadin 0.2% Eye Drops 5ml', NULL, NULL, NULL, 'Indiana Ophthalmics LLp', '8906078363189', 2, 13, 0, NULL, NULL, '2026-04-06 14:57:51', '2026-04-06 14:57:51', NULL),
(372, 'Camosunate Powder(Children 1-6Yrs)(Geneith Pharma Ltd)', 'Amodiaquin/Artesunate', '150mg', NULL, 'Geneith Pharma Ltd', '6928623000341', 2, 20, 0, NULL, NULL, '2026-04-06 14:59:29', '2026-04-06 14:59:29', NULL),
(373, 'Maxi Tears Eye drops 10ml Pharmacy Plus', NULL, NULL, NULL, 'Pharmacy Plus Ltd.', '8906007513920', 2, 13, 0, NULL, NULL, '2026-04-06 15:00:55', '2026-04-06 15:00:55', NULL),
(374, 'Pectol x36Tabs(Damel Group S.L)', 'Lozenges', NULL, NULL, 'Damel Group S.L', '84115508', 2, 11, 0, NULL, NULL, '2026-04-06 15:02:28', '2026-04-06 15:02:28', NULL),
(375, 'Antallerge Sterile Eye Drops 10ml DrugField', NULL, NULL, NULL, 'DrugField Pharma Ltd.', '6156000132600', 2, 13, 0, NULL, NULL, '2026-04-06 15:03:25', '2026-04-06 15:03:25', NULL),
(376, 'Pidogrel Clopidogrel 75mg 3x10tabs Zolon  /Card', NULL, '75mg', 'tablet', 'Emzor Pharma Industries Ltd.', '6156000262895', 2, 23, 0, NULL, NULL, '2026-04-06 15:09:17', '2026-04-06 15:09:17', NULL),
(377, 'Neurovit Forte 10x10Tabs(Hovid)', 'Neurovit', NULL, NULL, 'Hovid', 'UNEU39', 2, 26, 0, NULL, NULL, '2026-04-06 15:12:13', '2026-04-06 15:12:13', NULL),
(378, 'Pilorem-HCT Telmi Amlo Hydro 80/10/25 3x10tabs Apex /Card', NULL, NULL, 'tablet', 'Apex Pharma Pvt. Ltd.', 'PILOREM-HCT801025', 2, 23, 0, NULL, NULL, '2026-04-06 15:15:07', '2026-04-06 15:15:07', NULL),
(379, 'Pilorem Telmisartan Amlodipine 40/5 3x10tabs Apex /Card', NULL, NULL, 'tablet', 'Apex Formulations Pvt. Ltd', 'PILOREM-40/5', 2, 23, 0, NULL, NULL, '2026-04-06 15:18:56', '2026-04-06 15:18:56', NULL),
(380, 'Biophage Metformin 500mg 6x14tabs SKG /Card', NULL, '500mg', 'tablet', 'SKG-Pharma Ltd.', '6154000399306', 2, 22, 0, NULL, NULL, '2026-04-06 15:22:50', '2026-04-06 15:22:50', NULL),
(381, 'Losartan Postassium 25mg 2x14 tabs Pocco /Card', NULL, '25mg', 'tablet', 'Scott-Edil Pharma ltd.', '8904159414362', 2, 23, 0, NULL, NULL, '2026-04-06 15:26:41', '2026-04-06 15:26:41', NULL),
(382, 'Astin-20 Atorvastatin 20mg 3x10tabs Micro lab /Card', NULL, '20mg', 'tablet', 'Micro labs Ltd.', 'ASTIN-20MG', 2, 23, 0, NULL, NULL, '2026-04-06 15:30:18', '2026-04-06 15:30:18', NULL),
(383, 'Koils Matricaria Infant Teething Powder *Per Satchet x20 sachets', NULL, NULL, NULL, 'Bhargava Phytolab Pvt. Ltd.', '036000291452', 2, 10, 0, NULL, NULL, '2026-04-06 15:35:05', '2026-04-17 13:30:42', NULL),
(384, 'Asmalyn Salbutamol Syrup 100ml(Mopsan)', 'Salbutamol', '100ml', NULL, 'Mopson', '6154000295103', 2, 6, 0, NULL, NULL, '2026-04-06 15:37:02', '2026-04-06 15:37:02', NULL),
(385, 'Torsinex-100 Torsemide 100mg 3x10tabs Micro lab /Card', NULL, '100mg', 'tablet', 'Micro Lab Ltd.', 'TORSINEX-100MG', 2, 23, 0, NULL, NULL, '2026-04-06 15:38:32', '2026-04-06 15:38:32', NULL),
(386, 'Bonababe Baby Syrup 60ml(Bond Chemical Indust. Ltd)', 'Paracetamol', '60ml', NULL, 'Bond Chemical Ltd', '070125989252', 2, 10, 0, NULL, NULL, '2026-04-06 15:40:01', '2026-04-06 15:40:01', NULL),
(387, 'Broncholyte Syrup 100ml(Sygen)', 'Cough Syrup', '100ml', NULL, 'Sygen Pharma Ltd', '6156000067636', 2, 11, 0, NULL, NULL, '2026-04-06 15:42:45', '2026-04-06 15:42:45', NULL),
(388, 'Stugeron Cinnarizine 25mg 5x10tabs Aspi /Cardn', NULL, '25mg', 'tablet', 'Aspin Pharma Pvt. Ltd.', 'STUGERON25MG', 2, 6, 0, NULL, NULL, '2026-04-06 15:46:02', '2026-04-12 16:59:42', NULL),
(389, 'Codolin Expectorant Cough Syrup 100ml(Tuyil Pharma. Indu Ltd)', 'Cough Syrup', '100ml', NULL, 'Tuyil Pharma ind. Ltd', 'CODOLIN100ML', 2, NULL, 0, NULL, NULL, '2026-04-06 15:47:45', '2026-04-12 16:22:22', '2026-04-12 16:22:22'),
(390, 'Vitamin-K1 10mg Injection 10Amp x1ml /Ampoule', NULL, '10mg', 'injection', 'Anhui Chengshi Pharma Co. Ltd.', '1020481084344', 2, 12, 0, NULL, NULL, '2026-04-06 15:51:16', '2026-04-06 15:51:16', NULL),
(391, 'Cofex Cough Syrup 100ml(SKG)', 'Cough Syrup', '100ml', NULL, 'SKG', 'COFEX-100', 2, 11, 0, NULL, NULL, '2026-04-06 15:51:49', '2026-04-12 16:30:14', NULL),
(392, 'Cofex Cough Syrup 100ml(SKG)', 'Cough Syrup', '100ml', NULL, 'SKG', NULL, 2, 11, 0, NULL, NULL, '2026-04-06 15:54:13', '2026-04-06 15:54:13', NULL),
(393, 'Coflax Cough Syrup (Adult)100ml(SKG)', 'Cough Syrup', '100ml', NULL, 'SKG', '6156000081397', 2, 11, 0, NULL, NULL, '2026-04-06 15:56:22', '2026-04-06 15:58:09', NULL),
(394, 'Adrenaline 1mg Injection 1ml x10 Amp  /Ampoules', NULL, '1mg', 'injection', 'Shanxi Shuguang Pharma co. ltd.', 'SPANADREN-1MG', 2, NULL, 0, NULL, NULL, '2026-04-06 15:59:44', '2026-04-18 15:45:45', NULL),
(395, 'Curecee Vitamin C+Glucose x24Tabs(Unicure Pharma Ltd)', 'Vitamins', '200mg', NULL, 'Unicure Pharma Ltd', '6156000152806', 2, 12, 0, NULL, NULL, '2026-04-06 16:01:08', '2026-04-06 16:01:08', NULL),
(396, 'Coflin Expectorant Syrup 100ml(Vitabiotic)', 'Cough Syrup', '100ml', NULL, 'Vitabiotics Ltd', 'COFLIN-EXPECTORANT', 2, 11, 0, NULL, NULL, '2026-04-06 16:05:16', '2026-04-12 10:23:42', NULL),
(397, 'Dapzin-5 Dapagliflozin 5mg 3x10tabs Micro Lab /Card', NULL, '5mg', 'tablet', 'Micro Labs Ltd.', 'DAPZIN-5MG', 2, 22, 0, NULL, NULL, '2026-04-06 16:06:09', '2026-04-06 16:06:09', NULL),
(398, 'Emzolyn Cough Syrup 100ml (Emzor Pharma Ltd)', 'Cough Syrup', '100ml', NULL, 'Emzor Pharma Ltd', '6154000034108', 2, 11, 0, NULL, NULL, '2026-04-06 16:10:40', '2026-04-06 16:10:40', NULL),
(399, 'Dapzin-10 Dapagliflozin 10mg 3x10tabs Micro Lab /Card', NULL, '10mg', 'tablet', 'Micro lab Ltd.', 'DAPZIN-10MG', 2, 22, 0, NULL, NULL, '2026-04-06 16:11:04', '2026-04-06 16:11:04', NULL),
(400, 'Evans Glucose D 175g Tin(Evans Baroque Ltd)', 'Glucose', '175mg', NULL, 'Evans Baroque', 'GLUCOSED175', 2, 12, 0, NULL, NULL, '2026-04-06 16:14:22', '2026-04-12 16:35:45', NULL),
(401, 'Carzepin Carbamazepine 200mg 10x10 tabs Hovid /Card', NULL, '200mg', 'tablet', 'Hovid Bhd.', 'UCAR21', 2, 25, 0, NULL, NULL, '2026-04-06 16:18:09', '2026-04-06 16:18:09', NULL),
(402, 'Labet Labetalol 200mg 3x10tabs Popular /Card', NULL, '200mg', 'tablet', 'Popular Pharma ltd.', 'LABET-200MG', 2, 23, 0, NULL, NULL, '2026-04-06 16:21:33', '2026-04-06 16:21:33', NULL),
(403, 'Lamotrigine 100mg 8x7tabs Milpharm /Card', 'Lamotrigine', '100mg', 'tablet', 'Milpharm Ltd.', '8901175005970', 2, 25, 0, NULL, NULL, '2026-04-06 16:25:31', '2026-04-06 16:35:05', NULL),
(404, 'Lamotrigine 25mg 8x7tabs Milpharm /Card', 'Lamotrigine', '25mg', 'tablet', 'Milpharm Ltd.', '8901175005956', 2, 25, 0, NULL, NULL, '2026-04-06 16:39:41', '2026-04-06 16:39:41', NULL),
(405, 'Kold Time 48x4Tabs(Laborate Pharma(India)', 'Antiallergy', NULL, NULL, 'Laborate Pharma Ltd', '8906045940252', 2, 6, 0, NULL, NULL, '2026-04-06 16:48:06', '2026-04-06 16:48:06', NULL),
(406, 'Tuxil Cold & flu Day & Night 18/6Caps Fidson /Card', NULL, NULL, 'capsule', 'Fidson Healthcare Plc.', '6151100490193', 2, 11, 0, NULL, NULL, '2026-04-06 16:49:01', '2026-04-06 16:49:01', NULL),
(407, 'Maldox Suspen 15ml(Emzor Pharma Ltd)', 'Maldox', '15ml', NULL, 'Emzor Pharma Ltd', '6154000033798', 2, 20, 0, NULL, NULL, '2026-04-06 16:52:29', '2026-04-06 16:52:29', NULL),
(408, 'Benchie Mentholated Balm 100g(Benchiebest Worldlink Ltd)', 'Menthol', '100g', NULL, 'Bechiebest Worldlink Ltd', 'BENCHIE100G', 2, 10, 0, NULL, NULL, '2026-04-06 16:57:18', '2026-04-12 16:08:21', NULL),
(409, 'Dettol Germ Defence Antiseptic Disinfectant 500ml', NULL, NULL, NULL, 'Reckitt Benckiser Nigeria Ltd.', '6151100281883', 2, 16, 0, NULL, NULL, '2026-04-07 11:22:40', '2026-04-07 11:22:40', NULL),
(410, 'Dettol Germ Defence Antiseptic Disinfectant 250ml', NULL, NULL, NULL, 'Reckitt Benckiser Nigeria Ltd.', '6151100281876', 2, 16, 0, NULL, NULL, '2026-04-07 11:25:34', '2026-04-07 11:25:34', NULL),
(411, 'Dettol Germ Defence Antiseptic Disinfectant 165ml', NULL, NULL, NULL, 'Reckitt Benckiser Nigeria Ltd.', '6151100281869', 2, 16, 0, NULL, NULL, '2026-04-07 11:27:51', '2026-04-07 11:27:51', NULL),
(412, 'Goya Extra Virgin Olive Oil 88.7 ml', NULL, NULL, NULL, NULL, '041331011037', 2, NULL, 0, NULL, NULL, '2026-04-07 11:33:50', '2026-04-07 11:33:50', NULL),
(413, 'Obigod Crystalline Benzyl Penicillin Injection  /Vial', NULL, '1000000 I.U.', 'injection', 'Shandong Xier Kangtai Pharma Co., Ltd.', '6977234271138', 2, 8, 0, NULL, NULL, '2026-04-07 11:38:06', '2026-04-07 11:38:06', NULL),
(414, 'Hexedene Mouthwash Hexetidine 100ml Pharma Deko', NULL, NULL, NULL, NULL, '6156000213279', 2, 1, 0, NULL, NULL, '2026-04-07 11:41:48', '2026-04-07 11:41:48', NULL),
(415, 'Loratyn-10 Loratadine 10mg 10x10 tabs Hovid /Card', NULL, NULL, 'tablet', 'Hovid Bhd.', 'ULOR48', 2, 6, 0, NULL, NULL, '2026-04-07 11:45:32', '2026-04-07 11:45:32', NULL),
(416, 'Glucophage Metformin 1000mg 2x15tabs Merck /Card', NULL, '1000mg', 'tablet', 'Merck', 'GLUCOPHAGE-1000MG', 2, 22, 0, NULL, NULL, '2026-04-07 11:51:17', '2026-04-07 11:51:17', NULL),
(417, 'Glucophage Metformin 500mg 2x15tabs Merck /Card', NULL, '500mg', 'tablet', 'Merck', 'GLUCOPHAGE-500MG', 2, 22, 0, NULL, NULL, '2026-04-07 11:54:13', '2026-04-07 11:54:13', NULL),
(418, 'Lisinopril 10mg 2x14 tabs Pocco /Card', NULL, '10mg', 'tablet', 'Scott-Edil Pharma Ltd.', '8904159401058', 2, 23, 0, NULL, NULL, '2026-04-07 11:58:17', '2026-04-07 11:58:17', NULL),
(419, 'Moclopin-100 Clozapine 100mg 3x10 tabs /Card', NULL, '100mg', 'tablet', 'Micro labs Ltd.', 'MOCLOPIN-100MG', 2, 25, 0, NULL, NULL, '2026-04-07 12:04:38', '2026-04-07 12:04:38', NULL),
(420, 'Bisoprolol Fumarate 10mg 2x14tabs Sandoz /Card', NULL, '10mg', 'tablet', 'Sandoz Ltd.', '5015915917126', 2, 23, 0, NULL, NULL, '2026-04-07 12:08:42', '2026-04-07 12:08:42', NULL),
(421, 'Bisoprolol Fumarate 2.5mg 2x14tabs Sandoz /Card', NULL, '2.5mg', 'tablet', 'Sandoz Ltd.', '5015915917089', 2, 23, 0, NULL, NULL, '2026-04-07 12:12:42', '2026-04-07 12:12:42', NULL),
(422, 'Eden Amlodpine Besylate 10mg 2x14tabs /Card', NULL, '10mg', 'tablet', 'Genesis Pharma', 'EDEN-AMLODIPINE10MG', 2, 23, 0, NULL, NULL, '2026-04-07 12:22:10', '2026-04-07 12:22:10', NULL),
(423, 'Vildamet Vildagliptin & Metformin 50/1000mg 30tabs (Geneith) /Card', NULL, '50/1000mg', 'tablet', 'Geneith Pharma Ltd.', '8906103542350', 2, 23, 0, NULL, NULL, '2026-04-07 12:28:14', '2026-04-07 12:29:45', NULL),
(424, 'Norflex Orphenadrine 50mg 2x10tabs Boon Goldstar /Card', NULL, '50mg', 'tablet', 'Boon Goldstar International', '0118906047658657', 2, 27, 0, NULL, NULL, '2026-04-07 12:50:13', '2026-04-07 12:50:13', NULL),
(425, 'Norgesic Orphenadrine + Para 2x10 tabs Boon Goldstar /Card', NULL, NULL, 'tablet', 'Boon Goldstar International', '18906047658640', 2, 27, 0, NULL, NULL, '2026-04-07 12:56:00', '2026-04-07 12:56:00', NULL),
(426, 'Diastop Kaolin Light Suspension 200mg/ml Afrab', NULL, '200mg', 'syrup', 'Afrab-Chem Ltd.', '6154000240134', 2, 7, 0, NULL, NULL, '2026-04-07 13:03:00', '2026-04-07 13:03:00', NULL),
(427, 'Valsartil Valsartan Hydro 160/12.5mg 3x10tabs Incepta /Card', NULL, '160/12.5', 'tablet', 'Incepta Pharma Ltd.', 'VALSARTIL-160/12.5', 2, 23, 0, NULL, NULL, '2026-04-07 13:07:30', '2026-04-07 13:07:30', NULL),
(428, 'Atenolol 100mg 2x14 tabs Pocco /Card', NULL, '100mg', 'tablet', 'Scott-Edil Pharma Ltd.', '8904159401034', 2, 23, 0, NULL, NULL, '2026-04-07 13:13:55', '2026-04-07 13:13:55', NULL),
(429, 'Atenolol 50mg 2x14 tabs Pocco /Card', NULL, '50mg', 'tablet', 'Scott-Edil Pharma Ltd.', '8904159401027', 2, 23, 0, NULL, NULL, '2026-04-07 13:17:09', '2026-04-07 13:17:09', NULL),
(430, 'Bendroflumethiazide 5mg 2x14tabs Accord /Card', NULL, '5mg', 'tablet', 'Accord', '5012617009807', 2, 23, 0, NULL, NULL, '2026-04-07 13:20:40', '2026-04-07 13:20:40', NULL),
(431, 'Bendroflumethiazide 2.5mg 2x14tabs Accord /Card', NULL, '2.5mg', 'tablet', 'Accord', '5012617009791', 2, 23, 0, NULL, NULL, '2026-04-07 13:23:57', '2026-04-07 13:23:57', NULL),
(432, 'Carvedilol 25mg 2x14tabs Ciron Drugs & Pharma Ltd. /Card', NULL, '25mg', 'tablet', 'Ciron Drugs & Pharma Pvt. Ltd.', 'CARVEDILOL25-CIRON', 2, 23, 0, NULL, NULL, '2026-04-07 13:28:06', '2026-04-07 13:44:27', NULL),
(433, 'Carvedilol 3.125mg 2x14tabs Ciron Drugs & Pharma Ltd. /Card', NULL, '3.125mg', NULL, 'Ciron Drugs & Pharma Pvt. Ltd.', 'CARVEDILOL3.125-CIRON', 2, 23, 0, NULL, NULL, '2026-04-07 13:40:16', '2026-04-07 13:40:16', NULL),
(434, 'Amlodipine Besilate 10mg 2x14tabs Teva /Card', NULL, '10mg', 'tablet', 'Teva UK Ltd.', '5017007023371', 2, 23, 0, NULL, NULL, '2026-04-07 13:50:00', '2026-04-07 13:50:00', NULL),
(435, 'Arbitel-AM Telmisartan & Amlodipin 40mg/5mg 3x10tabs Micro lab /Card', NULL, '40MG/5MG', 'tablet', 'Micro Labs Limited-Unit III', 'ARBITEL-AM-40/5', 2, 23, 0, NULL, NULL, '2026-04-07 13:55:35', '2026-04-07 13:55:35', NULL),
(436, 'Losartan Potassium 50mg 2x14tabs Pocco /Card', NULL, '50mg', 'tablet', 'Scott-Edil Pharma ltd.', '8904159402420', 2, 23, 0, NULL, NULL, '2026-04-07 14:00:39', '2026-04-07 14:00:39', NULL),
(437, 'Druphagan Brimonidine Sterile Eye Drops 0.2%  DGF', NULL, NULL, 'drops', 'Drugfield Pharma Ltd.', '6156000158273', 2, 13, 0, NULL, NULL, '2026-04-07 14:04:35', '2026-04-07 14:04:35', NULL),
(438, 'Ahmad mint green tea', NULL, NULL, NULL, 'AHMAD TEA', '054881007511', 4, NULL, 0, NULL, NULL, '2026-04-07 14:05:17', '2026-04-07 14:05:17', NULL),
(439, 'Ahmad mint green tea', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-07 14:07:13', '2026-04-12 14:12:41', '2026-04-12 14:12:41'),
(440, 'Druphagan Plus Brimoni. Timolol Sterile Eye Drops 0.2%/0.5% DGF', NULL, NULL, 'drops', 'Drugfield Pharma Ltd.', '6156000223957', 2, 13, 0, NULL, NULL, '2026-04-07 14:07:29', '2026-04-07 14:07:29', NULL),
(441, 'Ahmad green tea', NULL, NULL, NULL, NULL, 'AHMAD-GREENTEA', 4, NULL, 0, NULL, NULL, '2026-04-07 14:13:32', '2026-04-12 14:12:12', NULL),
(442, 'Angizaar-100 Losartan Pot 100mg 3x10tabs Micro Lab /Card', NULL, '100mg', 'tablet', 'Micro Lab Ltd.', 'ANGIZAAR-100', 2, 23, 0, NULL, NULL, '2026-04-07 14:15:20', '2026-04-07 14:15:20', NULL),
(443, 'Exeter corned beef 200g', NULL, NULL, NULL, NULL, '7899567247163', 4, NULL, 0, NULL, NULL, '2026-04-07 14:18:15', '2026-04-07 14:18:15', NULL),
(444, 'Betadrone-N Eye/Ear/Nasal drops 10ml DGF', NULL, NULL, 'drops', 'Drugfield Pharma Ltd.', '6156000127552', 2, 13, 0, NULL, NULL, '2026-04-07 14:19:09', '2026-04-07 14:19:09', NULL),
(445, 'Eyemolol Timolol Eye Drops 0.5% 10ml AL-Tinez Pharma Ltd.', NULL, NULL, 'drops', 'Al-Tinez Pharma Ltd.', '8906018276517', 2, 13, 0, NULL, NULL, '2026-04-07 14:23:29', '2026-04-07 14:23:29', NULL),
(446, 'Green Giant sweet corn 340g', NULL, NULL, NULL, NULL, '3254474000005', 4, NULL, 0, NULL, NULL, '2026-04-07 14:25:22', '2026-04-07 14:25:22', NULL),
(447, 'Advant Candesartan 8mg 4x7tabs Getz Pharma /Card', NULL, '8mg', 'tablet', 'Getz Pharma', 'ADVANT-8MG-28', 2, 23, 0, NULL, NULL, '2026-04-07 14:26:14', '2026-04-07 14:26:14', NULL),
(448, 'Advant Candesartan 16mg 4x7tabs Getz Pharma /Card', NULL, '16mg', 'tablet', 'Getz Pharma', 'ADVANT-16MG-28', 2, 23, 0, NULL, NULL, '2026-04-07 14:28:49', '2026-04-07 14:28:49', NULL),
(449, 'Dental Floss', NULL, NULL, NULL, NULL, '6971324829315', 4, NULL, 0, NULL, NULL, '2026-04-07 14:30:02', '2026-04-07 14:30:02', NULL),
(450, 'Advantec 16mg + 12.5mg 4x7 tabs Getz Pharma /Card', NULL, '16mg/12.5mg', 'tablet', 'Getz Pharma', 'ADVANTEC-16/12.5MG', 2, 23, 0, NULL, NULL, '2026-04-07 14:32:03', '2026-04-07 14:32:03', NULL),
(451, 'Wash the king sponge', NULL, NULL, NULL, NULL, '6972512870331', 4, NULL, 0, NULL, NULL, '2026-04-07 14:32:34', '2026-04-07 14:32:34', NULL),
(452, 'Amanda Scourers sponge', NULL, NULL, NULL, NULL, '720355050818', 4, NULL, 0, NULL, NULL, '2026-04-07 14:35:08', '2026-04-07 14:35:08', NULL),
(453, 'Enaretic 10mg/25mg 3x10tabs E Pharma ltd. /Card', NULL, '10mg/25m', 'tablet', 'E pharma Ethics ltd', 'ENARETIC-10/25MG', 2, 23, 0, NULL, NULL, '2026-04-07 14:37:14', '2026-04-07 14:37:14', NULL),
(454, 'DEVON KINS PURE VEGETABLE OIL 1L', NULL, NULL, NULL, NULL, '6154000016678', 4, NULL, 0, NULL, NULL, '2026-04-07 14:42:18', '2026-04-07 14:42:18', NULL),
(455, 'Scanax Pregabalin 75mg 3x10 Caps Swipha /Card', NULL, '75mg', 'tablet', 'Baroque Pharma Pvt. Ltd.', '18904115704466', 2, 26, 0, NULL, NULL, '2026-04-07 14:44:35', '2026-04-07 14:44:35', NULL),
(456, 'Ribena black currant fruit drink 250ml', NULL, NULL, NULL, NULL, '6164003477932', 4, NULL, 0, NULL, NULL, '2026-04-07 14:47:12', '2026-04-07 14:47:12', NULL),
(457, 'Paroxetine 20mg 3x10tabs Sandoz /Card', NULL, '20mg', 'tablet', 'Sandoz Ltd.', '5015915935038', 2, NULL, 0, NULL, NULL, '2026-04-07 14:48:22', '2026-04-07 14:48:22', NULL),
(458, 'ribena straberry 250ml', NULL, NULL, NULL, NULL, '6161113670024', 4, NULL, 0, NULL, NULL, '2026-04-07 14:53:05', '2026-04-07 14:53:05', NULL),
(459, 'fresh yo drinking yoghurt 650ml', NULL, NULL, NULL, NULL, '6154000102524', 4, NULL, 0, NULL, NULL, '2026-04-08 08:50:55', '2026-04-08 08:50:55', NULL),
(460, 'Chivita Active Citrus mix 315ml', NULL, NULL, NULL, NULL, '6151100056290', 4, NULL, 0, NULL, NULL, '2026-04-08 08:58:16', '2026-04-08 08:58:16', NULL),
(461, 'maltina classic 33cl', NULL, NULL, NULL, NULL, '5025866000181', 4, NULL, 0, NULL, NULL, '2026-04-08 08:59:49', '2026-04-08 08:59:49', NULL),
(462, 'maltina classic pet bottle 33cl', NULL, NULL, NULL, NULL, '5025866001096', 4, NULL, 0, NULL, NULL, '2026-04-08 09:13:07', '2026-04-08 09:13:07', NULL),
(463, 'coca cola pet bottle 50cl', NULL, NULL, NULL, NULL, '5449000297280', 4, NULL, 0, NULL, NULL, '2026-04-08 09:17:16', '2026-04-08 09:17:16', NULL),
(464, 'fanta orange flavoured drink 50cl', NULL, NULL, NULL, NULL, '40822938', 4, NULL, 0, NULL, NULL, '2026-04-08 09:21:22', '2026-04-08 09:21:22', NULL),
(465, 'schweppes  non alcholic chapman drink 33cl', NULL, NULL, NULL, NULL, '5449000268686', 4, NULL, 0, NULL, NULL, '2026-04-08 09:25:12', '2026-04-08 09:25:12', NULL),
(466, 'indomie onion chicken flavor 120g', NULL, NULL, NULL, NULL, '089686130201', 4, NULL, 0, NULL, NULL, '2026-04-08 09:33:55', '2026-04-08 09:33:55', NULL),
(467, 'indomie chicken flavour120g', NULL, NULL, NULL, NULL, '089686130027', 4, NULL, 0, NULL, NULL, '2026-04-08 10:01:53', '2026-04-08 10:01:53', NULL),
(468, 'indomie onion flavour 70g', NULL, NULL, NULL, NULL, '089686130195', 4, NULL, 0, NULL, NULL, '2026-04-08 10:10:50', '2026-04-08 10:10:50', NULL),
(469, 'indomie chicken flavour 70g', NULL, NULL, NULL, NULL, '089686130010', 4, NULL, 0, NULL, NULL, '2026-04-08 10:14:45', '2026-04-08 10:14:45', NULL),
(470, 'gold kili honey ginger drink 18g', NULL, NULL, NULL, NULL, '8888296019058', 4, NULL, 0, NULL, NULL, '2026-04-08 10:33:52', '2026-04-08 10:33:52', NULL),
(471, 'nescafe gold blend decafe 95g', NULL, NULL, NULL, NULL, '8445291692763', 4, NULL, 0, NULL, NULL, '2026-04-08 10:40:20', '2026-04-08 10:40:20', NULL),
(472, 'power extra heavy duty foil10m', NULL, NULL, NULL, NULL, '769373645101', 4, NULL, 0, NULL, NULL, '2026-04-08 10:50:40', '2026-04-08 10:50:40', NULL),
(473, 'Varrosa cling film 300mm*20m', NULL, NULL, NULL, NULL, '13635471296', 4, NULL, 0, NULL, NULL, '2026-04-08 12:17:31', '2026-04-08 12:17:31', NULL),
(474, 'Baby Care perfume jelly 250ml', NULL, NULL, NULL, NULL, '6154000016913', 4, NULL, 0, NULL, NULL, '2026-04-08 12:32:50', '2026-04-08 12:32:50', NULL),
(475, 'tetmosol medicated soap citronella 75g', NULL, NULL, NULL, NULL, '6009826820018', 4, NULL, 0, NULL, NULL, '2026-04-08 12:41:51', '2026-04-08 12:41:51', NULL),
(476, 'Tetmosol medicated soap citronella 120g', NULL, NULL, NULL, NULL, '6009826820025', 4, NULL, 0, NULL, NULL, '2026-04-08 12:49:32', '2026-04-08 12:49:32', NULL),
(477, 'Viva Plus Detergent Powder 170g', NULL, NULL, NULL, NULL, '705632130018', 4, NULL, 0, NULL, NULL, '2026-04-08 12:57:28', '2026-04-12 16:57:21', NULL),
(478, 'Viva plus detergent powder 800g', NULL, NULL, NULL, NULL, '705632130001', 4, NULL, 0, NULL, NULL, '2026-04-08 13:05:37', '2026-04-08 13:05:37', NULL),
(479, 'Cussons baby soap70g', NULL, NULL, NULL, NULL, '6154000018658', 4, NULL, 0, NULL, NULL, '2026-04-08 13:11:30', '2026-04-08 13:11:30', NULL),
(480, 'Cusson baby soft and smooth soap 70g', NULL, NULL, NULL, NULL, '6154000017019', 4, NULL, 0, NULL, NULL, '2026-04-08 13:17:42', '2026-04-08 13:17:42', NULL),
(481, 'Blue Blue', NULL, NULL, NULL, NULL, '6034000482584', 4, NULL, 0, NULL, NULL, '2026-04-08 13:23:24', '2026-04-08 13:23:24', NULL),
(482, 'Blue Band Spread 250g', NULL, NULL, NULL, NULL, 'BLUE250G', 4, NULL, 0, NULL, NULL, '2026-04-08 13:25:59', '2026-04-12 16:09:40', NULL),
(483, 'vaseline blue seal  pet jelly 50ml', NULL, NULL, NULL, NULL, '6151100139511', 4, NULL, 0, NULL, NULL, '2026-04-08 13:30:49', '2026-04-08 13:30:49', NULL),
(484, 'pepsodent cavity fighter gel130g', NULL, NULL, NULL, NULL, '6151100130754', 4, NULL, 0, NULL, NULL, '2026-04-08 13:36:55', '2026-04-08 13:36:55', NULL),
(485, 'BAMA mayonnaise 810ml', NULL, NULL, NULL, NULL, '8410300367673', 4, NULL, 0, NULL, NULL, '2026-04-08 13:50:24', '2026-04-08 13:50:24', NULL),
(486, 'kellogg\'s coco pop 360g', NULL, NULL, NULL, NULL, '615400031783617836', 4, NULL, 0, NULL, NULL, '2026-04-08 14:17:15', '2026-04-08 14:17:15', NULL),
(487, 'Blue Band original spread', NULL, NULL, NULL, NULL, '6034000482515', 4, NULL, 0, NULL, NULL, '2026-04-08 14:24:40', '2026-04-08 14:24:40', NULL),
(488, 'Golden Penny spread 900g', NULL, NULL, NULL, NULL, '6154000041588', 4, NULL, 0, NULL, NULL, '2026-04-08 14:28:12', '2026-04-08 14:28:12', NULL),
(489, 'QUAKER quick cooking white oats 385g', NULL, NULL, NULL, NULL, '6009710723463', 4, NULL, 0, NULL, NULL, '2026-04-08 14:32:52', '2026-04-08 14:32:52', NULL),
(490, 'Colgate flouride charcoal tooth paste120g', NULL, NULL, NULL, NULL, '8718951350885', 4, NULL, 0, NULL, NULL, '2026-04-08 14:37:28', '2026-04-08 14:37:28', NULL),
(491, 'Oracare Extra Fresh Gel toothpaste 130g', NULL, NULL, NULL, NULL, '745110908623', 4, NULL, 0, NULL, NULL, '2026-04-08 14:42:45', '2026-04-08 14:42:45', NULL),
(492, 'Peak chocolate 3 in 1 refil 380g', NULL, NULL, NULL, NULL, '6154000054281', 4, NULL, 0, NULL, NULL, '2026-04-08 14:49:40', '2026-04-08 14:49:40', NULL),
(493, 'TOP TEA round tea  bags 50g', NULL, NULL, NULL, NULL, '6008155000849', 4, NULL, 0, NULL, NULL, '2026-04-08 14:56:45', '2026-04-08 14:56:45', NULL),
(494, 'So Kiln Concentrated Detergent 170g', NULL, NULL, NULL, NULL, '8998866628853', 4, NULL, 0, NULL, NULL, '2026-04-09 07:19:29', '2026-04-12 16:56:00', NULL),
(495, 'Good Mama floral bliss powder detergent 800g', NULL, NULL, NULL, NULL, '8998866622189', 4, NULL, 0, NULL, NULL, '2026-04-09 07:27:56', '2026-04-09 07:27:56', NULL),
(496, 'Dabur Herbal Basil oral protection 130g', NULL, NULL, NULL, NULL, '5022496101370', 4, NULL, 0, NULL, NULL, '2026-04-09 07:34:24', '2026-04-09 07:34:24', NULL),
(497, 'schweppes bitter lemon 40cl', NULL, NULL, NULL, NULL, '5449000273789', 4, NULL, 0, NULL, NULL, '2026-04-09 07:45:05', '2026-04-09 07:45:05', NULL),
(498, 'Sprite lemon-lime flavored drink 50cl', NULL, NULL, NULL, NULL, '54491069', 4, NULL, 0, NULL, NULL, '2026-04-09 07:48:33', '2026-04-09 07:48:33', NULL),
(499, 'Sprite lemon-lime flavored drink 35cl', NULL, NULL, NULL, NULL, '40822099', 4, NULL, 0, NULL, NULL, '2026-04-09 07:52:16', '2026-04-09 07:52:16', NULL),
(500, 'Fanta orange flavoured drink 35cl', NULL, NULL, NULL, NULL, '90377884', 4, NULL, 0, NULL, NULL, '2026-04-09 07:57:31', '2026-04-09 07:57:31', NULL),
(501, 'Coca-Cola 35cl', NULL, NULL, NULL, NULL, '42117131', 4, NULL, 0, NULL, NULL, '2026-04-09 08:04:50', '2026-04-09 08:04:50', NULL),
(502, 'Three Crowns filled evaporated milk', NULL, NULL, NULL, NULL, '8716200607544', 4, NULL, 0, NULL, NULL, '2026-04-09 08:09:46', '2026-04-09 08:09:46', NULL),
(503, 'Angel Cotton Swabs', NULL, NULL, NULL, NULL, '6972350940012', 4, NULL, 0, NULL, NULL, '2026-04-09 08:17:34', '2026-04-09 08:17:34', NULL),
(504, 'Dorco super sharp blades', NULL, NULL, NULL, NULL, '8801038586762', 4, NULL, 0, NULL, NULL, '2026-04-09 08:25:42', '2026-04-09 08:25:42', NULL),
(505, 'Dorco super sharp blades', NULL, NULL, NULL, NULL, '8801038586755', 4, NULL, 0, NULL, NULL, '2026-04-09 08:27:19', '2026-04-09 08:27:19', NULL),
(506, 'Bic original shaving stick', NULL, NULL, NULL, NULL, '3086126606552', 4, NULL, 0, NULL, NULL, '2026-04-09 08:33:05', '2026-04-09 08:33:05', NULL),
(507, 'Tiger head alkaline batteries', NULL, NULL, NULL, NULL, '6932620208099', 4, NULL, 0, NULL, NULL, '2026-04-09 08:37:51', '2026-04-09 08:37:51', NULL),
(508, 'McVitie\'s Hob nob oat biscuit', NULL, NULL, NULL, NULL, '6154000406011', 4, NULL, 0, NULL, NULL, '2026-04-09 09:34:58', '2026-04-09 09:34:58', NULL),
(509, 'McVitie\'s digestive wheat biscuit 52g', NULL, NULL, NULL, NULL, '5060482954180', 4, NULL, 0, NULL, NULL, '2026-04-09 09:42:08', '2026-04-09 09:42:08', NULL),
(510, 'Mentos chewing gum watermelon flavor175g', NULL, NULL, NULL, NULL, '8935001727873', 4, NULL, 0, NULL, NULL, '2026-04-09 09:49:59', '2026-04-09 09:49:59', NULL),
(511, 'Mentos chewing gum bubble fresh17.5g', NULL, NULL, NULL, NULL, '8935001727866', 4, NULL, 0, NULL, NULL, '2026-04-09 09:55:49', '2026-04-09 09:55:49', NULL),
(512, 'Mentos chewing gum straberry flavor 17.5g', NULL, NULL, NULL, NULL, '8935001727859', 4, NULL, 0, NULL, NULL, '2026-04-09 10:03:36', '2026-04-09 10:03:36', NULL),
(513, 'Kelita oat chocolate milk 10g', NULL, NULL, NULL, NULL, '6959462800397', 4, NULL, 0, NULL, NULL, '2026-04-09 10:07:59', '2026-04-09 10:07:59', NULL),
(514, 'John Rich original cream crackers 25g', NULL, NULL, NULL, NULL, '6919046610019', 4, NULL, 0, NULL, NULL, '2026-04-09 10:15:59', '2026-04-09 10:15:59', NULL),
(515, 'Kelita lollipop candy', NULL, NULL, NULL, NULL, '6922577100829', 4, NULL, 0, NULL, NULL, '2026-04-09 10:20:54', '2026-04-09 10:20:54', NULL),
(516, 'Mcvitie\'s butter shortbread 200g', NULL, NULL, NULL, NULL, '6154000067472', 4, NULL, 0, NULL, NULL, '2026-04-09 10:25:36', '2026-04-09 10:25:36', NULL),
(517, 'Mcvitie\'s butter shortbread 100g', NULL, NULL, NULL, NULL, '6154000067458', 4, NULL, 0, NULL, NULL, '2026-04-09 10:30:25', '2026-04-09 10:30:25', NULL),
(518, 'Mentos ice chewing gum orange flavour13g', NULL, NULL, NULL, NULL, '6154000043025', 4, NULL, 0, NULL, NULL, '2026-04-09 10:35:21', '2026-04-09 10:35:21', NULL),
(519, 'Mentos white chewing gum bubble fresh 13g', NULL, NULL, NULL, NULL, '6154000043902', 4, NULL, 0, NULL, NULL, '2026-04-09 10:39:56', '2026-04-09 10:39:56', NULL),
(520, 'VETO original shortbread butter cookies120g', NULL, NULL, NULL, NULL, '8909774000901', 4, NULL, 0, NULL, NULL, '2026-04-09 10:52:50', '2026-04-09 10:52:50', NULL),
(521, 'Navigable cheese crackers biscuit 100g', NULL, NULL, NULL, NULL, '6919046620643', 4, NULL, 0, NULL, NULL, '2026-04-09 10:55:26', '2026-04-09 10:55:26', NULL),
(522, 'Navigable coconut crackers biscuit 100g', NULL, NULL, NULL, NULL, '6919046620469', 4, NULL, 0, NULL, NULL, '2026-04-09 11:02:05', '2026-04-09 11:02:05', NULL),
(523, 'Center fresh chewing gum peppermint flavor', NULL, NULL, NULL, NULL, '6154000043629', 4, NULL, 0, NULL, NULL, '2026-04-09 11:05:08', '2026-04-09 11:05:08', NULL),
(524, 'Center fresh filled gum Mixed fruit flavor', NULL, NULL, NULL, NULL, '6154000043445', 4, NULL, 0, NULL, NULL, '2026-04-09 11:10:16', '2026-04-09 11:10:16', NULL),
(525, 'Tom tom strong menthol candy', NULL, NULL, NULL, NULL, '7622202379390', 4, NULL, 0, NULL, NULL, '2026-04-09 11:15:12', '2026-04-09 11:15:12', NULL),
(526, 'Tomtom freshlime flovored candy', NULL, NULL, NULL, NULL, '7622201782887https://breathewithtomtom.com/', 4, NULL, 0, NULL, NULL, '2026-04-09 11:18:47', '2026-04-09 11:18:47', NULL),
(527, 'VICKS blue medicated lozenges', NULL, NULL, NULL, NULL, '5000174823639', 4, NULL, 0, NULL, NULL, '2026-04-09 11:26:26', '2026-04-09 11:26:26', NULL),
(528, 'VICKS lemon plus medicated lozenges', NULL, NULL, NULL, NULL, '5000174823677', 4, NULL, 0, NULL, NULL, '2026-04-09 11:29:26', '2026-04-09 11:29:26', NULL),
(529, 'Pepsi cola flavored carbonated drink 50cl', NULL, NULL, NULL, NULL, '6034000005004', 4, NULL, 0, NULL, NULL, '2026-04-09 11:53:54', '2026-04-09 11:53:54', NULL),
(530, 'Climax energy drink 500ml', NULL, NULL, NULL, NULL, '5025866001829', 4, NULL, 0, NULL, NULL, '2026-04-09 11:57:31', '2026-04-09 11:57:31', NULL),
(531, 'Mirinda orange flavored soft drink 50cl', NULL, NULL, NULL, NULL, '6034000005103', 4, NULL, 0, NULL, NULL, '2026-04-09 12:01:39', '2026-04-09 12:01:39', NULL),
(532, 'Mirinda pineapple flavored soft drink 50cl', NULL, NULL, NULL, NULL, '6034000005110', 4, NULL, 0, NULL, NULL, '2026-04-09 12:05:22', '2026-04-09 12:05:22', NULL),
(533, 'Listerine cool mint mouthwash 500ml', NULL, NULL, NULL, NULL, '5010123703585', 4, NULL, 0, NULL, NULL, '2026-04-09 12:08:38', '2026-04-09 12:08:38', NULL),
(534, 'Colgate max white mouthwash 500ml', NULL, NULL, NULL, NULL, '8718951592223', 4, NULL, 0, NULL, NULL, '2026-04-09 12:13:10', '2026-04-09 12:13:10', NULL),
(535, 'Fanyogo sweetened yoghurt drink 300ml', NULL, NULL, NULL, NULL, '796554279091', 4, NULL, 0, NULL, NULL, '2026-04-09 12:34:48', '2026-04-09 12:34:48', NULL),
(536, 'Fanyogo strawberry flavored yoghurt drink 300ml', NULL, NULL, NULL, NULL, '796554279107', 4, NULL, 0, NULL, NULL, '2026-04-09 12:38:13', '2026-04-09 12:38:13', NULL),
(537, 'Paloma classic super soft tissue', NULL, NULL, NULL, NULL, '3838952002462', 4, NULL, 0, NULL, NULL, '2026-04-09 12:42:22', '2026-04-09 12:42:22', NULL),
(538, 'PPS comfort pocket tissue', NULL, NULL, NULL, NULL, '5030481970238', 4, NULL, 0, NULL, NULL, '2026-04-09 12:51:40', '2026-04-09 12:51:40', NULL),
(539, 'AIR WICK crisp linen & lilac', NULL, NULL, NULL, NULL, '5011417551721', 4, NULL, 0, NULL, NULL, '2026-04-09 12:57:42', '2026-04-09 12:57:42', NULL),
(540, 'Ambi pur lavender breeze air freshner 250ml', NULL, NULL, NULL, NULL, '4084500342064', 4, NULL, 0, NULL, NULL, '2026-04-09 13:05:31', '2026-04-09 13:05:31', NULL),
(541, '2sure pineapple splash hand wash 250ml', NULL, NULL, NULL, NULL, '6151100150967', 4, NULL, 0, NULL, NULL, '2026-04-09 13:10:33', '2026-04-10 12:45:18', NULL),
(542, '2Sure strawberry milkshake hand wash 250ml', NULL, NULL, NULL, NULL, '6151100150974', 4, NULL, 0, NULL, NULL, '2026-04-09 13:14:12', '2026-04-09 13:14:12', NULL),
(543, 'OMRON automatic upper arm blood pressure monitor', NULL, NULL, NULL, 'omron healthcare', '4015672111837', 2, NULL, 0, NULL, NULL, '2026-04-09 13:20:10', '2026-04-09 13:20:10', NULL),
(544, 'Little angel panty liners', NULL, NULL, NULL, NULL, '6958259358011', 4, NULL, 0, NULL, NULL, '2026-04-09 13:49:28', '2026-04-09 13:49:28', NULL),
(545, 'Dry love sanitary napkin 280mm', NULL, NULL, NULL, NULL, '6921269110207', 4, NULL, 0, NULL, NULL, '2026-04-09 13:56:51', '2026-04-09 13:56:51', NULL),
(546, 'LADY SEPT super sanitary towels', NULL, NULL, NULL, NULL, '6156000291123', 4, NULL, 0, NULL, NULL, '2026-04-09 14:03:12', '2026-04-09 14:03:12', NULL),
(547, 'MOLFIX junior diaper 11-25kg', NULL, NULL, NULL, NULL, '8690536816538', 4, NULL, 0, NULL, NULL, '2026-04-09 14:11:04', '2026-04-09 14:11:04', NULL),
(548, 'Softcare premium soft M 3-8kg', NULL, NULL, NULL, NULL, '6156000346076', 4, NULL, 0, NULL, NULL, '2026-04-09 14:19:22', '2026-04-09 14:19:22', NULL),
(549, 'Rosuvastatin 10mg 3x10tabs Swipha /Card', NULL, '10mg', 'tablet', 'Baroque Pharma Pvt. Ltd.', '18904115703186', 2, 23, 0, NULL, NULL, '2026-04-10 12:51:17', '2026-04-10 12:51:17', NULL),
(550, 'Silver Bird 100% Eucalyptus Oil Bells 28ml', NULL, NULL, NULL, 'Bells Sons & Co Ltd', '5017848251537', 2, 11, 0, NULL, NULL, '2026-04-10 12:56:32', '2026-04-10 12:56:32', NULL),
(551, 'Sertraline 50mg 2x14tabs Milpharm /Card', NULL, '50mg', 'tablet', 'Milpharm Ltd.', '8901175007455', 2, 25, 0, NULL, NULL, '2026-04-10 12:59:50', '2026-04-10 12:59:50', NULL),
(552, 'Deep Heat Spray 150ml(Colep Lauphem & Co. Ltd)', 'Anti-Imflammation', '150ml', NULL, 'Colep Laupheim Co. Ltd', '5011501004553', 2, 10, 0, NULL, NULL, '2026-04-10 13:04:37', '2026-04-10 13:04:37', NULL),
(553, 'Angizaar-50 Losartan Pot. 50mg 3x10tabs Micro Lab /Card', NULL, '50mg', 'tablet', 'Micro Labs Ltd.', 'ANGIZAAR-50MG', 2, 23, 0, NULL, NULL, '2026-04-10 13:04:42', '2026-04-10 13:04:42', NULL);
INSERT INTO `drugs` (`id`, `brand_name`, `generic_name`, `strength`, `dosage_form`, `manufacturer`, `barcode`, `category_id`, `subcategory_id`, `is_prescription_only`, `controlled_substance_class`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(554, 'Gentalab Eye/Ear Drops 0.3% w/v 10ml Laborate Pharma.Ltd.', NULL, NULL, 'drops', 'Embassy Pharma Ltd.', '8906045940641', 2, 13, 0, NULL, NULL, '2026-04-10 13:10:53', '2026-04-10 13:10:53', NULL),
(555, 'Aldomet 250mg Methylopa x60Tabs(Aspen Port Elizabeth (Pty) Ltd', 'Aldomet', '250mg', NULL, 'Aspen Port Elizabeth (Pty) Ltd', '6001390123335', 2, 28, 0, NULL, NULL, '2026-04-10 13:12:43', '2026-04-10 13:12:43', NULL),
(556, 'Mepiryl Glimepiride 2mg 3x10tabs May & Baker /Card', NULL, '2mg', 'tablet', 'May & Baker Nigeria Plc.', '6151006000267', 2, 22, 0, NULL, NULL, '2026-04-10 13:14:14', '2026-04-10 13:14:14', NULL),
(557, 'Mepiryl Glimepiride 4mg 3x10tabs May & Baker /Card', NULL, '4mg', 'tablet', 'May & Baker Nigeria Plc.', '6151006000274', 2, 22, 0, NULL, NULL, '2026-04-10 13:16:34', '2026-04-10 13:16:34', NULL),
(558, 'Krishat 1000mg Cod Liver Oil 2x15Caps(Krishat Pharma Ltd)', 'Cod Liver', NULL, NULL, 'Krishat Pharma Ltd', '653468571669', 2, 12, 0, NULL, NULL, '2026-04-10 13:16:47', '2026-04-10 13:16:47', NULL),
(559, 'Artequick Tabet(Artepharm Co. Ltd )', 'Artequick', '437.5', NULL, 'Artepharm Co. Ltd', '6940999101019', 2, 20, 0, NULL, NULL, '2026-04-10 13:20:27', '2026-04-10 13:20:27', NULL),
(560, 'Ramipril 10mg 2x14Caps Multichris /Card', NULL, '10mg', 'capsule', 'Relax Biotech Pvt. Ltd.', 'RAMIPRIL-10MG-RELAX', 2, 23, 0, NULL, NULL, '2026-04-10 13:20:45', '2026-04-10 13:20:45', NULL),
(561, 'Kacham Caplets 2x10 Cpt', 'Kacham', '625mg', NULL, 'Kunimed', '6152110057017', 2, 10, 0, NULL, NULL, '2026-04-10 13:23:31', '2026-04-10 13:23:31', NULL),
(562, 'Aprovasc Irbesartan/Amlodipine 300/10mg 2x14tabs Sanofi /Card', NULL, '300mg/10mg', 'tablet', 'Sanofi', '3582910068969', 2, 23, 0, NULL, NULL, '2026-04-10 13:24:46', '2026-04-10 13:24:46', NULL),
(563, 'Nifecard XL Nifedipine 30mg 3x10tabs Glek /Card', NULL, '30mg', 'tablet', 'Novartis Pharma Manufacturing LLC', '3838957396368', 2, 23, 0, NULL, NULL, '2026-04-10 13:28:20', '2026-04-10 13:28:20', NULL),
(564, 'Voltaren emulgel 116% Gel 50g(Haleon Tuketici Istanbul)', 'Inflammationary Gel', '50g', NULL, 'Haleon Tuketici Instabul', '8681291340079', 2, 10, 0, NULL, NULL, '2026-04-10 13:28:37', '2026-04-10 13:28:37', NULL),
(565, 'B-Cor 5 Bisoprolol 5mg 2x15 tabs Afrab-Chem Ltd /Card', NULL, '5mg', 'tablet', 'Afrab-Chem Ltd.', '6154000240967', 2, 23, 0, NULL, NULL, '2026-04-10 13:31:09', '2026-04-10 13:31:09', NULL),
(566, 'Ibunova 400mg 6x10 Softgel(Mega LifeSciences Public Company Ltd)', 'Ibuprofen', '400mg', NULL, 'Mega LifeSciences Public Company Ltd', '8850769022247', 2, 10, 0, NULL, NULL, '2026-04-10 13:32:24', '2026-04-10 13:32:24', NULL),
(567, 'Clozotic Ear Drops 5ml Universal Life Science', NULL, NULL, 'tablet', 'Universal Life Science', 'CLOZOTIC-EAR-DROPS', 2, 13, 0, NULL, NULL, '2026-04-10 13:35:30', '2026-04-10 13:35:30', NULL),
(568, 'Act Clartem-QS x6Tabs(Claron Medicals Ltd)', 'Clartem', '560mg', NULL, 'Claron Medicals Ltd', '8901117123656', 2, 20, 0, NULL, NULL, '2026-04-10 13:37:16', '2026-04-10 13:37:16', NULL),
(569, 'Esidrex Hydrochlorotiazide 25mg 2x10tabs Juvise Pharma /Card', NULL, '25mg', 'tablet', 'Juvise Pharma', '0GDN80', 2, 23, 0, NULL, NULL, '2026-04-10 13:39:17', '2026-04-10 13:39:17', NULL),
(570, 'Dabur Odomos Cream (Dabur India Ltd)', 'Odomos', '15g', NULL, 'Dabur India Ltd', '8901207801051', 2, 29, 0, NULL, NULL, '2026-04-10 13:42:03', '2026-04-10 13:42:03', NULL),
(571, 'Gynaemed clotrimazole x6 Virginal Tabs(Synmedic Labor)', 'Clotrimazole', NULL, NULL, 'Synmedic Labor', '8905250002533', 2, 4, 0, NULL, NULL, '2026-04-10 13:45:17', '2026-04-10 13:45:17', NULL),
(572, 'Febo-G Febuxostat 40mg 3x10tabs Getz /Card', NULL, '40mg', 'tablet', 'Getz Pharma.', 'FEBO-G-40MG', 2, 26, 0, NULL, NULL, '2026-04-10 13:46:00', '2026-04-10 13:46:00', NULL),
(573, 'Omeshal D x10Caps(Shalina Labor. Pvt Ltd)', 'Omeprazole', '20mg', NULL, 'Shalina Labor. Pvt Ltd', '8902292004983', 2, 7, 0, NULL, NULL, '2026-04-10 13:48:10', '2026-04-10 13:48:10', NULL),
(574, 'Glucophage XR Metformin 1000mg 3x10tabs Merck /Card', NULL, '1000mg', 'tablet', 'Merck Sante', 'GLUCOPHAGEXR-1000', 2, 22, 0, NULL, NULL, '2026-04-10 13:49:44', '2026-04-10 13:49:44', NULL),
(575, 'Ibucap 20x10 Caps(Shalina Labor. Pvt Ltd)', 'Ibuprofen', NULL, NULL, 'Shalina Labor. Pvt. Ltd', '0108902292605630', 2, 10, 0, NULL, NULL, '2026-04-10 13:51:39', '2026-04-10 13:51:39', NULL),
(576, 'Malven Lidocaine & Adrenaline Inj 50ml Alpa Loborat.', NULL, NULL, 'injection', 'Alpa Laboratories Ltd.', 'MALVEN-50ML-INJ', 2, 5, 0, NULL, NULL, '2026-04-10 13:54:38', '2026-04-10 13:54:38', NULL),
(577, 'Felvin 20mg Piroxicam 10x10Caps(GreenLife Pharma Ltd)', 'Piroxicam', '20mg', NULL, 'GreenLife Pharma Ltd', '8906081306357', 2, 10, 0, NULL, NULL, '2026-04-10 13:54:47', '2026-04-10 13:54:47', NULL),
(578, 'Normoretic 5/50mg 10x10tabs Neimeth /Card', NULL, '5/50mg', 'tablet', 'Neimeth Int\'L Pharma., Plc.', 'NORMORETIC-5/50', 2, 23, 0, NULL, NULL, '2026-04-10 13:57:48', '2026-04-10 13:57:48', NULL),
(579, 'MIM 5x6Caps(Adler Vitabiotics)', 'Blood Builder', NULL, NULL, 'Vitabiotics', '8904008420230', 2, 12, 0, NULL, NULL, '2026-04-10 13:58:14', '2026-04-10 13:58:14', NULL),
(580, 'Acycor Plus x10Tabs(Reals Pharma Ltd)', 'Paracetamol', NULL, NULL, 'Reals Pharma Ltd', 'ACYCORPLUS-100MG', 2, 10, 0, NULL, NULL, '2026-04-10 14:01:52', '2026-04-12 14:09:46', NULL),
(581, 'Naza Fortified Procaine Penicilline 4Mega Inj Vials', NULL, NULL, 'injection', 'Shanxi Zhongbao Shuguang Pharm Co. Ltd.', 'NAZA-PROCAINE-PENI', 2, 8, 0, NULL, NULL, '2026-04-10 14:01:57', '2026-04-10 14:01:57', NULL),
(582, 'Medmoral 3x10Tabs(Laborate Pharma Ltd)', 'Trypsin', NULL, NULL, 'Laborate Pharma Ltd', 'MEDMORAL30', 2, 10, 0, NULL, NULL, '2026-04-10 14:05:12', '2026-04-12 16:44:25', NULL),
(583, 'Realflex Phenyramidol 400mg 3x10tabs Reals /Card', NULL, '400mg', 'tablet', 'Reals Pharma Ltd.', '0118906047630073', 2, 27, 0, NULL, NULL, '2026-04-10 14:05:51', '2026-04-10 14:05:51', NULL),
(584, 'Cloflam100 10x10Tabs(TransGlobe Pharma Co. Ltd)', 'Diclofenac', '100mg', NULL, 'TransGlobe Pharma Co. Ltd', 'CLOFLAM100MG', 2, 10, 0, NULL, NULL, '2026-04-10 14:09:31', '2026-04-12 16:14:29', NULL),
(585, 'Simlo-5 Amlodipine & Losartan Pot 5mg/50mg. 3x10tabs Leotetra /Card', NULL, '5mg/50mg', 'tablet', 'Innova Captab Ltd.', 'SIMLO-5', 2, 23, 0, NULL, NULL, '2026-04-10 14:11:44', '2026-04-10 14:11:44', NULL),
(586, 'Peflotab 400mg Pefloxacin x10Tabs(Fidson)', 'Pefloxacin', '400mg', NULL, 'Fidson', '8906001820352', 2, 20, 0, NULL, NULL, '2026-04-10 14:14:21', '2026-04-10 14:14:21', NULL),
(587, 'Klovinal 1x6 Vaginal Pessaries(Bliss Gvs Pharma Ltd)', 'Klovinal', NULL, NULL, 'Bliss Gvs Pharma Ltd', '8906009230535', 2, 4, 0, NULL, NULL, '2026-04-10 14:17:21', '2026-04-10 14:17:21', NULL),
(588, 'Thiapril Ramipril & Hydro 5.0mg/12.5mg 3x10tabs M&B /Card', NULL, '5mg/12.5mg', 'tablet', 'May & Baker Nigeria Plc', '6151006000113', 2, 23, 0, NULL, NULL, '2026-04-10 14:21:07', '2026-04-10 14:21:07', NULL),
(589, 'P-Alaxin 1x9Tabs(Bliss Gvs Pharma Ltd)', 'P-Alaxin', '360mg', NULL, 'Bliss Gvs Pharma Ltd', 'D1AW027', 2, 20, 0, NULL, NULL, '2026-04-10 14:21:07', '2026-04-12 12:38:07', NULL),
(590, 'Turbovas-10 Rosuvastatin 10mg 3x10tabs Micro Lab /Card', NULL, '10mg', 'tablet', 'Micro Labs Ltd.', 'TURBOVAS-10MG', 2, 23, 0, NULL, NULL, '2026-04-10 14:24:31', '2026-04-10 14:24:31', NULL),
(591, 'Lonart-DS x60Tabs(Bliss Gvs Pharma Ltd)', 'Lonart', '560mg', NULL, 'Bliss Gvs Pharma Ltd', '8906009238180', 2, 20, 0, NULL, NULL, '2026-04-10 14:24:40', '2026-04-10 14:24:40', NULL),
(592, 'Valvas Amlodipine 10mg & Valsartan 160mg 3x10tabs Popular /Card', NULL, '10/160mg', 'tablet', 'Popular Pharma. Ltd.', 'VALVAS-10/160', 2, 23, 0, NULL, NULL, '2026-04-10 14:28:52', '2026-04-10 14:28:52', NULL),
(593, 'Ceflonac-SP x10Tabs(Geneith Pharma Ltd)', 'Clofenac', NULL, NULL, 'Geneith Pharma Ltd', '8906045884266', 2, 10, 0, NULL, NULL, '2026-04-10 14:34:31', '2026-04-10 14:34:31', NULL),
(594, 'Petasil Metoclopramide Hydro 10mg Chupet Pharm. /Amp', NULL, '10mg', 'injection', 'Chupet Pharm. Co. Ltd.', 'PETASIL-INJECTION', 2, 5, 0, NULL, NULL, '2026-04-10 14:35:31', '2026-04-10 14:36:00', NULL),
(595, 'Kinbrex 200mg Celecoxib x10caps(Kingzy Pharma Ltd)', 'Celecoxib', '200mg', NULL, 'Kingzy Pharma Ltd', '8906046353150', 2, 7, 0, NULL, NULL, '2026-04-10 14:39:01', '2026-04-10 14:39:01', NULL),
(596, 'Artesun Artesunate 120mg I.M/I.V Fosun Pharma', NULL, '120mg', 'injection', 'Fosun Pharma', '6920108100829', 2, 20, 0, NULL, NULL, '2026-04-10 14:40:15', '2026-04-10 14:40:15', NULL),
(597, 'Ciprotab -D Ciprofloxacin + Dexa  Eye/Ear Drops  Aventra', NULL, NULL, 'drops', 'Fidon Healthcare Plc.', '6034000140316', 2, 13, 0, NULL, NULL, '2026-04-10 14:52:04', '2026-04-10 14:52:04', NULL),
(598, 'Procold 50x4Tabs(Orange Kalbe Ltd)', 'Procold', NULL, NULL, 'Orange Kalbe Ltd', '8993218663230', 2, 11, 0, NULL, NULL, '2026-04-10 14:54:07', '2026-04-10 14:54:07', NULL),
(599, 'Naza Dexamethasone Inj 4mg/1ml Naza Pharma. Ltd. /Amp', NULL, '4mg', 'injection', 'Naza Pharma Ltd.', 'NAZA-4MG', 2, 6, 0, NULL, NULL, '2026-04-10 14:55:09', '2026-04-10 14:55:09', NULL),
(600, 'Mixagrip 25x4Tabs((Orange Kalbe Ltd)', 'Mixagrip', NULL, NULL, '(Orange Kalbe Ltd', '8995858187558', 2, 11, 0, NULL, NULL, '2026-04-10 14:57:21', '2026-04-10 14:57:21', NULL),
(601, 'FloraNorm Saccharomyces 10 Sachets Prisma /Sachet', NULL, NULL, NULL, 'Prisma Pharma.', 'FLORANORM-25000', 2, 9, 0, NULL, NULL, '2026-04-10 15:00:03', '2026-04-10 15:00:03', NULL),
(602, 'Flucamed Fluconazole Sterile Eye Drops 5ml DGF', NULL, NULL, 'drops', 'Drugfield Pharma. Ltd.', '6156000132662', 2, 13, 0, NULL, NULL, '2026-04-10 15:02:24', '2026-04-10 15:02:24', NULL),
(603, 'Fortide Budesonide +Formoterol Inhaler 200/6mcg Getz', NULL, NULL, NULL, 'Getz Pharma', 'FORTIDE-200+6MCG', 2, 6, 0, NULL, NULL, '2026-04-10 15:05:47', '2026-04-10 15:05:47', NULL),
(604, 'Naza Gentamycin Sulphate 80mg/2ml Inj Naza Pharma. /Amp', NULL, '80mg', 'injection', 'Naza Pharma. Ltd.', 'NAZA-80MG', 2, 8, 0, NULL, NULL, '2026-04-10 15:08:43', '2026-04-10 15:08:43', NULL),
(605, 'Aday Kit Tablets(Clarion Medicals)', 'Aday Kit', NULL, NULL, 'Clarion Medicals', 'ADAY-KIT', 2, 4, 0, NULL, NULL, '2026-04-10 15:10:43', '2026-04-12 14:10:24', NULL),
(606, 'Getryl Glimepiride 2mg 3x10tabs Getz Pharma /Card', NULL, '2mg', 'tablet', 'Getz Pharma.', 'GETRYL-2MG', 2, 22, 0, NULL, NULL, '2026-04-10 15:18:50', '2026-04-10 15:18:50', NULL),
(607, 'Ascochew Vitamin C Chewable x100Tabs(Diamond Healthcare Ltd)', 'Vitamin', '100mg', NULL, 'Diamond Healthcare Ltd', 'ASCOCHEW-COLORED', 2, 12, 0, NULL, NULL, '2026-04-10 15:20:36', '2026-04-12 14:00:35', NULL),
(608, 'Getryl Glimepiride 4mg 3x10tabs Getz Pharma /Card', NULL, '4mg', 'tablet', 'Getz Pharma.', 'GETRYL-4MG', 2, 22, 0, NULL, NULL, '2026-04-10 15:22:36', '2026-04-10 15:22:36', NULL),
(609, 'Dr. Meyer\'s B-Complex High Potency x100Tabs(Vitabiotics)', 'Vitamin', '100mg', NULL, 'Vitabiotics', 'COMPLEX100', 2, 12, 0, NULL, NULL, '2026-04-10 15:24:22', '2026-04-12 16:33:53', NULL),
(610, 'Hydrocortisone Sodium 100mg I.M/I.V Bazreal /Vial', NULL, '100mg', 'injection', 'Shandong Xier Kangtai Pharma. Co. Ltd.', 'BAZREL-100MG', 2, 8, 0, NULL, NULL, '2026-04-10 15:26:55', '2026-04-10 15:26:55', NULL),
(611, 'RBCare Rabeprazole Sodium 1x10Tabs(Dony-Triumph)', 'Rabeprazole', '20mg', NULL, 'Dony-Triumph Ltd/Medico Remedies Ltd', '8904181403891', 2, 7, 0, NULL, NULL, '2026-04-10 15:29:35', '2026-04-10 15:29:35', NULL),
(612, 'Knox Cimetidine 200mg/2ml injection Knox Pharma. /Amp', NULL, '200mg', 'injection', 'Knox Pharma. Ltd.', 'KNOX-200MG', 2, 7, 0, NULL, NULL, '2026-04-10 15:29:42', '2026-04-10 15:29:42', NULL),
(613, 'Ketha Methyldopa 250mg 10x10tabs Vixa Pharma. /Card', NULL, '250mg', 'tablet', 'Vixa Pharma. Co. Ltd', '6971161600467', 2, 23, 0, NULL, NULL, '2026-04-10 15:33:23', '2026-04-10 15:33:23', NULL),
(614, 'Biocoten Anti-Eczematous Cream 20g(DGF)', 'Biocoten', '20g', NULL, 'DGF', '6156000081328', 2, 4, 0, NULL, NULL, '2026-04-10 15:34:30', '2026-04-10 15:34:30', NULL),
(615, 'Archy Zinc Sulphate 20mg 10x10tabs Archy Pharma. /Card', NULL, '20mg', 'tablet', 'Archy Pharma. Nig. Ltd', 'ARCHY-20MG', 2, 12, 0, NULL, NULL, '2026-04-10 15:38:09', '2026-04-10 15:38:09', NULL),
(616, 'Bunto Multivitamin & Minerals x30Caps(Tuyil Pharma Ind. Ltd)', 'Blood Builder', NULL, NULL, 'Tuyil Pharma. Indu. Ltd', 'BUNTO30CAPS', 2, 9, 0, NULL, NULL, '2026-04-10 15:40:06', '2026-04-12 16:11:12', NULL),
(617, 'Yoyo Cleanser Bitters 100% Herbal 200ml', NULL, NULL, 'syrup', 'Ablat Company Nig. Ltd.', '445937180003', 2, 12, 0, NULL, NULL, '2026-04-10 15:42:23', '2026-04-10 15:42:23', NULL),
(618, 'Boska tabs x2Blister  *Per Card (Orange Drugs Ltd)', 'Paracetamol', NULL, NULL, 'Orange Drugs Ltd', 'BOSKA20', 2, 10, 0, NULL, NULL, '2026-04-10 15:44:45', '2026-04-17 13:05:06', NULL),
(619, 'Xyzal Levocetirizine 5mg 10tabs Gsk', NULL, '5mg', 'tablet', 'UCB Farchim SA', 'XYZAL-5MG', 2, 6, 0, NULL, NULL, '2026-04-10 15:45:35', '2026-04-10 15:45:35', NULL),
(620, 'Stray High Strength Vitamin E 1000 IU 10x10Caps /Card', NULL, '1000 IU', 'capsule', 'St. Nonny Ray Pharma. Ltd.', 'STRAY-1000IU', 2, 12, 0, NULL, NULL, '2026-04-10 15:49:17', '2026-04-10 15:49:17', NULL),
(621, 'Camosunate Adult 14 Years & Above (Geneith Pharma Ltd)', 'Camosunate', NULL, NULL, 'Geneith Pharma Ltd', '6928623000419', 2, 20, 0, NULL, NULL, '2026-04-10 15:50:13', '2026-04-10 15:50:13', NULL),
(622, 'Nature\'s Field Vitamin C 1000mg x100tabs Bottle', NULL, '1000mg', 'tablet', NULL, '713757084802', 2, 12, 0, NULL, NULL, '2026-04-10 15:52:09', '2026-04-10 15:52:09', NULL),
(623, 'Cenox-TN Ciprofloxacin 500mg(Elbe Pharma Nig. Ltd)', 'Ciprofloxacin', '500mg', NULL, 'Elbe Pharma Ltd', '8906003878993', 2, 8, 0, NULL, NULL, '2026-04-10 15:56:05', '2026-04-10 15:56:05', NULL),
(624, 'Tansudart Dutasteride 05mg Tamsulosin 0.4mg 3x10Caps /Card', NULL, NULL, 'capsule', 'Eldoxa Ltd.', 'TAMSUDART-0.5MG', 2, 30, 0, NULL, NULL, '2026-04-10 15:57:27', '2026-04-10 15:57:27', NULL),
(625, 'Synergo Cabergoline 0.5mg 4x2 tabs Popular', NULL, '0.5mg', 'tablet', 'Popular Pharma Ltd.', 'SYNERGO-0.5MG', 2, 21, 0, NULL, NULL, '2026-04-10 16:01:49', '2026-04-10 16:01:49', NULL),
(626, 'Cypri Gold 3x10Caplets(Therapeutic Laborat. Nig. Ltd)', 'Vitamin', '4mg', NULL, 'Therapeutic Laborat. Nig. Ltd', '6156000381619', 2, 12, 0, NULL, NULL, '2026-04-10 16:02:05', '2026-04-10 16:02:05', NULL),
(627, 'Reload Women\'s 50+ Formula x30tabs', NULL, NULL, 'tablet', NULL, '615225000348', 2, 12, 0, NULL, NULL, '2026-04-10 16:04:15', '2026-04-10 16:04:15', NULL),
(628, 'Reload Men\'s 50+ Formula x30tabs', NULL, NULL, 'tablet', NULL, '615225000355', 2, 12, 0, NULL, NULL, '2026-04-10 16:05:58', '2026-04-10 16:05:58', NULL),
(629, 'Cloflam 50mg x10Tabs(Transglobe Pharma Co. Ltd)', 'Diclofenac', '50mg', NULL, 'Transglobe Pharma. Co. Ltd', 'CLOFLAM50MG', 2, 10, 0, NULL, NULL, '2026-04-10 16:06:25', '2026-04-12 16:13:56', NULL),
(630, 'Retin-A Tretinoin Cream 0.05% 30g Pramahanta Healthcare', NULL, NULL, 'cream', 'Pramahanta Healthcare', 'RETIN-A-30GM', 2, 31, 0, NULL, NULL, '2026-04-10 16:09:44', '2026-04-12 14:37:38', NULL),
(631, 'Coatal Forte 80/480 SoftGel Capsule(Geneith Pharma Ltd)', 'Coatal Forte', NULL, NULL, 'Geneith Pharma. Ltd', '8904220602131', 2, 20, 0, NULL, NULL, '2026-04-10 16:11:07', '2026-04-10 16:11:07', NULL),
(632, 'Permethrin Cream 5% 30g Maltobic', NULL, NULL, 'cream', 'Jiagxi Xier Kangtai Pharma Co. ltd.', 'PERMETHRIN-CREAM30G', 2, 31, 0, NULL, NULL, '2026-04-10 16:14:26', '2026-04-10 16:14:26', NULL),
(633, 'Natura House Omega 3-6-9 1000mg Fish oil 10x10 softgel /Card', NULL, '1000mg', 'capsule', 'Shandong Rosemed Biopharm LLC', 'NATURA-OMEGA369', 2, 12, 0, NULL, NULL, '2026-04-10 16:17:58', '2026-04-10 16:17:58', NULL),
(634, 'Deep Pain Cream 30g(Transglobe Pharma Co. Ltd)', 'Inflammatory Gel', '30g', NULL, 'Transglobe Pharma Co. Ltd', 'DEEPAIN30G', 2, 10, 0, NULL, NULL, '2026-04-10 16:20:13', '2026-04-12 16:32:31', NULL),
(635, 'Natura House Vitamin E 1000 IU 10x10 softgel /Card', NULL, '1000 IU', 'capsule', 'Shandong Rosemed Biopharm LLC', 'NATURA-VITAMINE', 2, 12, 0, NULL, NULL, '2026-04-10 16:21:38', '2026-04-10 16:21:38', NULL),
(636, 'Dolo-Meta B 10x10Tabs(Vixa Pharma. Co. Ltd)', 'Vitamin', NULL, NULL, 'Vixa Pharma. Co. Ltd', '6971161600016', 2, 12, 0, NULL, NULL, '2026-04-10 16:24:13', '2026-04-10 16:24:13', NULL),
(637, 'Kiss Condom dkt 3\'s x 36 Packs /Card', NULL, NULL, NULL, NULL, '8906016710587', 2, 17, 0, NULL, NULL, '2026-04-10 16:26:42', '2026-04-10 16:26:42', NULL),
(638, 'Natura House Omega Fish Oil 1000mg 10x10 softgel /Card', NULL, '1000mg', 'capsule', 'Shandong Rosemed Biopharm LLC', 'NATURA-FISHOIL', 2, 12, 0, NULL, NULL, '2026-04-10 16:30:03', '2026-04-10 16:30:03', NULL),
(639, 'Medicated Mentholated Dusting Powder 200g(PZ Cussons Nigeria', 'Powder', '200g', NULL, 'PZ Cussons Nigeria', '6154000015329', 2, 32, 0, NULL, NULL, '2026-04-10 16:30:40', '2026-04-10 16:30:40', NULL),
(640, 'Fastum Gel Ketoprofen 2.5% Menarini 100g', NULL, NULL, 'cream', NULL, 'FASTUM-GEL-100G', 2, 10, 0, NULL, NULL, '2026-04-10 16:32:54', '2026-04-10 16:32:54', NULL),
(641, 'Medicated Mentholated Dusting Powder 80g(PZ Cussons Nigeria)', 'Powder', '80g', NULL, 'PZ Cussons Nigeria', '6154000015343', 2, 32, 0, NULL, NULL, '2026-04-10 16:34:21', '2026-04-10 16:34:21', NULL),
(642, 'Fastum Gel Ketoprofen 2.5% Menarini 50g', NULL, NULL, 'cream', NULL, 'FASTUM-GEL-50G', 2, 10, 0, NULL, NULL, '2026-04-10 16:34:59', '2026-04-10 16:34:59', NULL),
(643, 'Enat 400 IU Natural Vitamin E Mega 3x10 Softgel Mega /Card', NULL, '400 IU', 'capsule', 'Mega', '8850769010138', 2, 12, 0, NULL, NULL, '2026-04-10 16:38:24', '2026-04-10 16:38:24', NULL),
(644, 'Eden Fluconazole 150mg 1x10Caps(Eden-Uk Pharma Ltd)', 'Fluconazole', '150mg', NULL, 'Eden-Uk Pharma Ltd', '8904181402160', 2, 4, 0, NULL, NULL, '2026-04-10 16:38:50', '2026-04-10 16:38:50', NULL),
(645, 'Ecoslim Orlistat 120mg 1x21 Caps Micro Lab', NULL, '120mg', 'capsule', 'Micro Labs Ltd.', 'ECOSLIM-120MG', 2, 12, 0, NULL, NULL, '2026-04-10 16:41:44', '2026-04-10 16:41:44', NULL),
(646, 'Emcap 500mg Paracetamol 10x10Tabs(Emzor Pharma Ltd)', 'Paracetamol', '500mg', NULL, 'Emzor Pharma Ltd', '6154000033057', 2, 10, 0, NULL, NULL, '2026-04-10 16:42:13', '2026-04-10 16:42:13', NULL),
(647, 'Drujela Choline + Cetalkonium Chloride Mouth gel 10g DGF', NULL, NULL, 'cream', 'DrugField Pharma Ltd.', '6156000081465', 2, 10, 0, NULL, NULL, '2026-04-10 16:44:58', '2026-04-10 16:44:58', NULL),
(648, 'Endix-G Cream 20g(Centaur Pharma Pvt. Ltd)', 'Endix-G', '20g', NULL, 'Centaur Pharma Pvt. Ltd', '8906013145207', 2, 4, 0, NULL, NULL, '2026-04-10 16:45:49', '2026-04-10 16:45:49', NULL),
(649, 'Cypron Cyproheptadine HCI 4mg 3x10Caplets  /Card', NULL, '4mg', 'tablet', 'Orange Karbe Limited', 'CYPRON-4MG', 2, 12, 0, NULL, NULL, '2026-04-10 16:48:48', '2026-04-10 16:48:48', NULL),
(650, 'Eproxen 500mg(Biogenerics Nig. Ltd)', 'Eproxen', '500mg', NULL, 'Biogenerics Nig. Ltd', 'EPROXEN500', 2, 10, 0, NULL, NULL, '2026-04-10 16:50:14', '2026-04-12 16:35:02', NULL),
(651, 'Ceftran Ceftriaxone 1g Injection IM/IV Standard Generics', NULL, '1g', 'injection', 'Standard Generics Ltd.', '8904210800127', 2, 8, 0, NULL, NULL, '2026-04-10 16:51:29', '2026-04-10 16:51:29', NULL),
(652, 'AntalgexT x20Caps(ExpharLab Ltd)', 'AntalgexT', NULL, NULL, 'ExpharLab Ltd', 'ANTALGEX-20', 2, 10, 0, NULL, NULL, '2026-04-10 16:57:03', '2026-04-12 14:14:09', NULL),
(653, 'Dr. Meyer\'s Folic Acid x100Tabs(Vitabiotics)', 'Vitamin', NULL, NULL, 'Vitabiotics', 'FOLIC100', 2, 12, 0, NULL, NULL, '2026-04-10 17:00:36', '2026-04-12 16:34:14', NULL),
(654, 'Fastum Gel Ketoprofen 50g(Philips Pharma Nig. Ltd)', 'Ketoprofen', NULL, NULL, 'Philips Pharma Nig. Ltd', 'FASTUN50G', 2, 10, 0, NULL, NULL, '2026-04-10 17:05:10', '2026-04-12 16:36:52', NULL),
(655, 'Ferobin Plus 3x10Caps(Fidson)', 'Blood Builder', NULL, NULL, 'Fidson', '6151100490063', 2, 9, 0, NULL, NULL, '2026-04-10 17:09:00', '2026-04-10 17:09:00', NULL),
(656, 'Loxagyl 400mg 10x10Tabs(M&B)', 'Metronidazole', '400mg', NULL, 'M&B', '6151006000175', 2, 8, 0, NULL, NULL, '2026-04-10 17:12:02', '2026-04-10 17:12:02', NULL),
(657, 'Amalar x3Tabs(Elbe Pharma Nig. Ltd)', 'Amalar', NULL, NULL, 'Elbe Pharma Nig. Ltd', 'AMALAR-TABS', 2, 20, 0, NULL, NULL, '2026-04-10 17:15:58', '2026-04-12 14:13:22', NULL),
(658, 'Amatem Forte Softgel x6Caps(Elbe Pharma Nig Ltd)', 'Amatem', NULL, NULL, 'Elbe Pharma Nig Ltd', '8906044917507', 2, 20, 0, NULL, NULL, '2026-04-10 17:19:25', '2026-04-10 17:19:25', NULL),
(659, 'Anacin 300mg Aspirin x144Tabs(SKG)', 'Aspirin', NULL, NULL, 'SKG', '608887011500', 2, 10, 0, NULL, NULL, '2026-04-10 17:22:27', '2026-04-10 17:22:27', NULL),
(660, 'Alpha Betic + For Diabetic Health Multi-Vitamin 30 Caplets', NULL, NULL, 'tablet', NULL, '033674101889', 2, 12, 0, NULL, NULL, '2026-04-11 12:35:00', '2026-04-11 12:35:00', NULL),
(661, 'Nutri-C American Sweet Orange Flavour Drink x10 Sachets /Sachet', NULL, NULL, NULL, NULL, '749921062345', 2, 12, 0, NULL, NULL, '2026-04-11 12:38:14', '2026-04-11 12:38:14', NULL),
(662, 'Embassy Evening Primrose Oil 500mg 3x10 Caps /Card', NULL, '500mg', 'capsule', 'Embassy Pharma. & Chemicals Ltd.', '339993078444491', 2, 12, 0, NULL, NULL, '2026-04-11 12:42:23', '2026-04-11 12:42:23', NULL),
(663, 'Immunboost Plus Calcium 500mg + Vitamin C 1000mg 20 Eff Basic Supp', NULL, NULL, 'tablet', NULL, '4022679131980', 2, 12, 0, NULL, NULL, '2026-04-11 12:46:27', '2026-04-11 12:46:27', NULL),
(664, 'Allopurinol 100mg x28Tabs(Ipca Laborate. UK Ltd)', 'Allopurinol', '100mg', NULL, 'Ipca Laborate. UK Ltd', '5060777420482', 2, 30, 0, NULL, NULL, '2026-04-11 12:47:27', '2026-04-11 12:47:27', NULL),
(665, 'Super Immun C Orange Flavour 20 Eff Tabs Basic Supp', NULL, NULL, 'tablet', NULL, '4022679144454', 2, 12, 0, NULL, NULL, '2026-04-11 12:49:15', '2026-04-11 12:49:15', NULL),
(666, 'Allopurinol 300mg x28Tabs(Ipca Laborate. Ltd)', 'Allopurinol', '300mg', NULL, 'Ipca Laborate Ltd', '5060777420499', 2, 30, 0, NULL, NULL, '2026-04-11 12:50:25', '2026-04-11 12:50:25', NULL),
(667, 'Nixoderm Cream For Skin Problems Tube 15g', NULL, NULL, 'cream', NULL, '5010182974421', 2, 31, 0, NULL, NULL, '2026-04-11 12:53:30', '2026-04-11 12:53:30', NULL),
(668, 'Anthisan Cream 25g(Phoenix Labs)', 'Mepyramine Maleate', '25g', NULL, 'Phoenix Labs', '5391513951725', 2, 6, 0, NULL, NULL, '2026-04-11 12:56:21', '2026-04-11 12:56:21', NULL),
(669, 'Emzor Paracetamol x96Tabs(Emzor Pharma. Indus. Ltd', 'Paracetamol', '500mg', NULL, 'Emzor Pharma Indus. Ltd', '6154000033002', 2, 10, 0, NULL, NULL, '2026-04-11 13:02:46', '2026-04-11 13:02:46', NULL),
(670, 'Anusol Ointment 3 Way Action 25g', NULL, NULL, 'cream', NULL, '5010724531013', 2, 33, 0, NULL, NULL, '2026-04-11 13:03:17', '2026-04-11 13:03:17', NULL),
(671, 'Diclofenac Gel 20g(DGF)', 'Diclofenac', '20g', NULL, 'DGF', '6156000132525', 2, 10, 0, NULL, NULL, '2026-04-11 13:06:17', '2026-04-11 13:06:17', NULL),
(672, 'Feroglobin B12 Haemoglobin & Red Blood Cell 2x15 Caps Vitabiotics /Card', NULL, NULL, 'capsule', 'Vitabiotics Ltd.', '5021265254613', 2, 9, 0, NULL, NULL, '2026-04-11 13:06:53', '2026-04-11 13:06:53', NULL),
(673, 'Wellwoman Original Health & Vitality 30Caps Vitabiotics', NULL, NULL, 'capsule', 'Vitabiotics', '5021265247714', 2, 12, 0, NULL, NULL, '2026-04-11 13:12:49', '2026-04-11 13:12:49', NULL),
(674, 'Tranexamic Acid 500mg x10Tabs(Merit Organics Ltd)', 'Tranexamic', '500mg', NULL, 'Merit organics Ltd', 'TRANE500', 2, 6, 0, NULL, NULL, '2026-04-11 13:14:25', '2026-04-12 16:57:45', NULL),
(675, 'Wellwoman 50+ Health & Vitality 30Caps Vitabiotics', NULL, NULL, NULL, 'Vitabiotics', '5021265247721', 2, 12, 0, NULL, NULL, '2026-04-11 13:16:10', '2026-04-11 13:16:10', NULL),
(676, 'Alpa-Xylogel Lidocaine 2% Jelly(Mankind Life-Sciences Ltd)', 'Lidocaine', '30gm', NULL, 'Mankind Life-Sciences Ltd', '8906018274735', 2, 10, 0, NULL, NULL, '2026-04-11 13:19:03', '2026-04-11 13:19:03', NULL),
(677, 'Wellman 70+ Health & Vitality 30 tabs Vitabiotics', NULL, NULL, 'tablet', 'Vitabiotics', '5021265249459', 2, 12, 0, NULL, NULL, '2026-04-11 13:20:09', '2026-04-11 13:20:09', NULL),
(678, 'ABF-3 Cream 20g(Bond Chemical Ind. Ltd)', 'Clotrimazole', '20g', NULL, 'Bond Chemical Indu. Ltd', '25147', 2, 8, 0, NULL, NULL, '2026-04-11 13:24:02', '2026-04-11 14:59:21', NULL),
(679, 'Wellwoman Plus Omega 3.6.9 Health & Vitality 56 tabs Vitabiotics', NULL, NULL, 'capsule', 'Vitabiotics', '5021265247738', 2, 12, 0, NULL, NULL, '2026-04-11 14:31:27', '2026-04-11 14:31:27', NULL),
(680, 'Advantan 0.1% Krem (Metilprednisolon)30g (Leo Abdibrahim)', 'Metilprednisolon Cream', '30g', NULL, 'Leo Abdibrahim', '8699514350255', 2, 6, 0, NULL, NULL, '2026-04-11 14:32:09', '2026-04-11 14:32:09', NULL),
(681, 'Immunace Selenium 30 Caps White Pack Vitabiotics', NULL, NULL, 'capsule', 'Vitabiotics', '5021265249435', 2, 12, 0, NULL, NULL, '2026-04-11 14:34:12', '2026-04-11 14:34:12', NULL),
(682, 'Aquasulf Sulfur Ointment 20g(Aphantee Pharma Nig. Ltd)', 'Sulfur Ointment', '20g', NULL, 'Aphantee Pharma Nig. Ltd', 'AQUASULF-20G', 2, 4, 0, NULL, NULL, '2026-04-11 14:35:17', '2026-04-12 14:22:16', NULL),
(683, 'Immunace Extra Protection Immune system 30tabs Vitabiotics', NULL, NULL, 'tablet', 'Vitabiotics', '5021265251889', 2, 12, 0, NULL, NULL, '2026-04-11 14:37:10', '2026-04-11 14:37:10', NULL),
(684, 'ArenaxPlus Artemether/Lumefantrine 20/120mg x6Tabs(Swipha)', 'Artemether', '20/120mg', NULL, 'Swipha', 'ARENAXPLUS-6TABS', 2, 20, 0, NULL, NULL, '2026-04-11 14:39:54', '2026-04-12 16:06:06', NULL),
(685, 'ArenaxPlus Artemether/Lumefantrine 20/120mg 3x6Tabs(Swipha', 'Artemether', '20/120mg', NULL, 'Swipha', 'ARENAXPLUS-28TABS', 2, 20, 0, NULL, NULL, '2026-04-11 14:42:14', '2026-04-12 16:04:56', NULL),
(686, 'Reload 4 Kidz 80 Chewable Tabs Multivitamin', NULL, NULL, 'tablet', NULL, '615225000188', 2, 12, 0, NULL, NULL, '2026-04-11 14:42:39', '2026-04-11 14:42:39', NULL),
(687, 'ArenaxPlus Artemether/Lumefantrine 20/120mg 4x6Tabs(Swipha', 'Artemether', '20/120mg', NULL, 'Swipha', 'ARENAXPLUS-24TABS', 2, 20, 0, NULL, NULL, '2026-04-11 14:44:07', '2026-04-12 16:05:34', NULL),
(688, 'Reload Women\'s Formula Multivitamin 30tabs', NULL, NULL, 'tablet', NULL, '615225000201', 2, 12, 0, NULL, NULL, '2026-04-11 14:44:53', '2026-04-11 14:44:53', NULL),
(689, 'Coartem 80/480 Artemether/Lumefan x6Tabs(Novartis)', 'Artemether', '80/480mg', NULL, 'Novartis', 'COARTEM80', 2, 20, 0, NULL, NULL, '2026-04-11 14:48:06', '2026-04-12 16:19:03', NULL),
(690, 'Reload Tonic dietry Supplement 237ml', NULL, NULL, 'syrup', NULL, '615225000379', 2, 9, 0, NULL, NULL, '2026-04-11 14:50:40', '2026-04-11 14:50:40', NULL),
(691, 'Dr. Hommels Extra Virgin Cod Liver Oil 200ml', NULL, NULL, 'syrup', NULL, '6159000249361', 2, 12, 0, NULL, NULL, '2026-04-11 14:53:38', '2026-04-11 14:53:38', NULL),
(692, 'Allergin Chlorpheniramine Maleate Syrup 60ml(Afrab)', 'Allergin', NULL, NULL, 'Afrab', '6154000240080', 2, 6, 0, NULL, NULL, '2026-04-11 14:54:24', '2026-04-11 14:54:24', NULL),
(693, 'Acneaway Cream 20g(Elbe Pharma Nig. Ltd)', 'Acneaway', NULL, NULL, 'Elbe Pharma Nig. Ltd', '714084870847', 2, 4, 0, NULL, NULL, '2026-04-11 14:58:32', '2026-04-11 14:58:32', NULL),
(694, 'Tydineal Ketoconazole Neomycin Clobetasol Cream Osworth 20g', NULL, NULL, 'cream', 'Front Pharma Plc.', '6928623097006', 2, 4, 0, NULL, NULL, '2026-04-11 15:01:52', '2026-04-11 15:01:52', NULL),
(695, 'Nature\'s Field Adam\'s Desire 15 Caps', NULL, NULL, 'capsule', NULL, '799872985927', 2, 17, 0, NULL, NULL, '2026-04-11 15:04:48', '2026-04-11 15:04:48', NULL),
(696, 'Dynamogen Oral Solution x20 10ml Faes Farma /5 Vials', NULL, NULL, NULL, 'FAES FARMA, S.A.', '8470007491279', 2, 9, 0, NULL, NULL, '2026-04-11 15:08:34', '2026-04-11 15:08:34', NULL),
(697, 'G-Oral Plus (Orange Flavour ORS) 41g(GreenLife Pharma Ltd)', 'ORS', NULL, NULL, 'GreenLife Pharma Ltd', 'GORALPLUS', 2, 34, 0, NULL, NULL, '2026-04-11 15:08:46', '2026-04-12 16:37:24', NULL),
(698, 'Hydrocortisone Cream 15g(DGF)', 'Hydrocort', '15g', NULL, 'DGF', '6156000127620', 2, 6, 0, NULL, NULL, '2026-04-11 15:11:38', '2026-04-11 15:11:38', NULL),
(699, 'Parlodel Bromocriptin 2.5mg 3x10tabs Viatris /Card', NULL, '2.5mg', 'tablet', 'Viatris', '8698856010032', 2, 21, 0, NULL, NULL, '2026-04-11 15:13:18', '2026-04-11 15:13:18', NULL),
(700, 'Hyperex-SR 1x10Caps(Leotetra HealthCare Ltd)', 'Rabeprazole Na', NULL, NULL, 'Leotetra HealthCare Ltd', 'HYPEREX-SR', 2, 7, 0, NULL, NULL, '2026-04-11 15:15:27', '2026-04-12 16:38:57', NULL),
(701, 'Supramult Original 30 Softgel Chi Pharma. Ltd.', NULL, NULL, 'capsule', 'Chi Pharma. Ltd.', '6152000502283', 2, 12, 0, NULL, NULL, '2026-04-11 15:16:22', '2026-04-11 15:19:02', NULL),
(702, 'Supramult Plus 30 Softgel Chi Pharma. Ltd.', NULL, NULL, 'capsule', 'Chi Pharma. Ltd.', '6152000502290', 2, 12, 0, NULL, NULL, '2026-04-11 15:19:08', '2026-04-11 15:19:08', NULL),
(703, 'Indokris 25mg  Indomethacine 10x10Caps(Krishat Pharma Indu. Ltd)', 'Indocind', '25mg', NULL, 'Krishat Pharma Indus. Ltd', '653468571539', 2, 10, 0, NULL, NULL, '2026-04-11 15:20:12', '2026-04-11 15:20:12', NULL),
(704, 'Klinfast Forte 1x7 Vaginal supposi.(Geneith Pharma Ltd)', 'Klinfast', NULL, NULL, 'Geneith Pharma Ltd', 'KLINFATFORTE', 2, 4, 0, NULL, NULL, '2026-04-11 15:23:07', '2026-04-12 16:39:56', NULL),
(705, 'Livolin Forte Hepatotonic 3x10 Softgel Mega  /Card', NULL, NULL, 'capsule', 'Mega Lifescience PTY. LTD.', '8850769013207', 2, 12, 0, NULL, NULL, '2026-04-11 15:26:33', '2026-04-11 15:28:29', NULL),
(706, 'Kenelog Oral Onitment 10g(SS Enterprize)', 'Acetonide', '10g', NULL, 'SS Enterprise', '5289A', 2, 6, 0, NULL, NULL, '2026-04-11 15:26:43', '2026-04-11 15:26:43', NULL),
(707, 'Ketofung Ketoconazole Cream 20g(DGF)', 'Ketoconazole', '20g', NULL, 'DFG', '6156000127507', 2, 4, 0, NULL, NULL, '2026-04-11 15:29:23', '2026-04-11 15:29:23', NULL),
(708, 'Nat B High Potency B Vitamin 3x10 Softgel Mega /Card', NULL, NULL, 'capsule', 'Mega Lifescience PTY. LTD.', '8850769015829', 2, 12, 0, NULL, NULL, '2026-04-11 15:30:26', '2026-04-11 15:30:26', NULL),
(709, 'Super Apeti Cyproheptadine 4mg 2x10 tabs Shalina', NULL, '4mg', 'tablet', 'Shalina Healthcare Nig. Ltd.', '0106156000315133', 2, 9, 0, NULL, NULL, '2026-04-11 15:35:51', '2026-04-11 15:37:50', NULL),
(710, 'Super Apeti Plus Syrup Cyproheptadine 200ml Shalina', NULL, NULL, 'syrup', 'Shalina Healthcare Nig. Ltd.', '0108902292004594', 2, 9, 0, NULL, NULL, '2026-04-11 15:40:25', '2026-04-11 15:40:25', NULL),
(711, 'Lixyped Children\'s Cough Syrup 100ml(M&B)', 'Lixyped', '100ml', NULL, 'M&B', '6151006000151', 2, 11, 0, NULL, NULL, '2026-04-11 15:43:16', '2026-04-11 15:43:16', NULL),
(712, 'Ciprotab - TN Ciprofloxacin + Tinidazole 10 Soflets Fidson', NULL, NULL, 'tablet', 'V.S. International Pvt. Ltd', '8906001822035', 2, 8, 0, NULL, NULL, '2026-04-11 15:43:45', '2026-04-11 15:43:45', NULL),
(713, 'Loratadine Syrup 60ml(Afrab)', 'Loratadine', '60ml', NULL, 'Afrab', '6154000240042', 2, 6, 0, NULL, NULL, '2026-04-11 15:47:14', '2026-04-11 15:47:14', NULL),
(714, 'Daravit Forte 6x5 SoftGelatin Caps Elbe', NULL, NULL, 'capsule', 'Elbe Pharma Nig. Ltd.', '8906044919839', 2, 12, 0, NULL, NULL, '2026-04-11 15:47:35', '2026-04-11 15:50:35', NULL),
(715, 'Paracetamol 8x12Tabs(M&B)', 'Paracetamol', '500mg', NULL, 'M&B', '6151006000229', 2, 10, 0, NULL, NULL, '2026-04-11 15:50:46', '2026-04-11 15:50:46', NULL),
(716, 'Maldox 1x3Tabs (Emzor Pharma Indus. Ltd)', 'Maldox', '500/25mg', NULL, 'Emzor Pharma Indus. Ltd', '6154000234027', 2, 20, 0, NULL, NULL, '2026-04-11 15:57:55', '2026-04-18 15:57:04', NULL),
(717, 'Xavat Vildagliptin/Metformin 50mg /1000mg  6x10 tabs Bezik /Card', NULL, '50/1000mg', 'tablet', 'Bezik Pharma. Ltd.', '8906104083159', 2, 22, 0, NULL, NULL, '2026-04-11 16:00:00', '2026-04-11 16:00:00', NULL),
(718, 'Meprazil-20mg Omeprazole 2x10Caps(Fidson)', 'Omeprazole', '20mg', NULL, 'Fidson', '6151100490582', 2, 7, 0, NULL, NULL, '2026-04-11 16:02:32', '2026-04-11 16:02:32', NULL),
(719, 'Alabukun Powder x10 Sachets /Sachet', NULL, NULL, NULL, NULL, 'ALABUKUN-POWDER', 2, 10, 0, NULL, NULL, '2026-04-11 16:05:14', '2026-04-11 16:05:14', NULL),
(720, 'Mycoten Cream 20g(DGF)', 'Mycoten', '20g', NULL, 'DGF', '6156000081311', 2, 4, 0, NULL, NULL, '2026-04-11 16:07:19', '2026-04-11 16:07:19', NULL),
(721, 'Ciprotab Ciprofloxacin 0.3% Eye Drops 10ml Aventra', NULL, NULL, 'drops', 'Fidson Healthcare Plc.', '6154000373658', 2, 13, 0, NULL, NULL, '2026-04-11 16:19:22', '2026-04-11 16:19:22', NULL),
(722, 'Mycoten Clotrimazole 100mg x6 Vaginal Tabs(DGF)', 'Mycoten', '100mg', NULL, 'DGF', '6156000127538', 2, 4, 0, NULL, NULL, '2026-04-11 16:21:07', '2026-04-11 16:21:07', NULL),
(723, 'Crystalline Penicilline Inj Obigod 10 Vials /Vial', NULL, '1000000 IU', 'injection', NULL, 'OBIGOD-CRYSTALLINE', 2, 8, 0, NULL, NULL, '2026-04-11 16:24:05', '2026-04-11 16:24:05', NULL),
(724, 'Mycoten Clotrimazole Solution 25ml(DGF)', 'Mycoten', '25ml', NULL, 'DGF', '18G0129', 2, 4, 0, NULL, NULL, '2026-04-11 16:24:38', '2026-04-11 16:24:38', NULL),
(725, 'Neo-Presol 25ml(DGF)', 'Neo-Presol', '25ml', NULL, 'DGF', '6156000081359', 2, 4, 0, NULL, NULL, '2026-04-11 16:27:43', '2026-04-11 16:27:43', NULL),
(726, 'Neurogesic Extra Onitment 35g(DGF)', 'Neurogesic', '35g', NULL, 'DGF', '6156000127590', 2, 10, 0, NULL, NULL, '2026-04-11 16:31:15', '2026-04-11 16:31:15', NULL),
(727, 'Masrone Risperidone 2mg 3x10 tabs Micro  Lab /Card', NULL, '2mg', 'tablet', 'Micro Labs Ltd.', 'MASRONE-2MG', 2, 25, 0, NULL, NULL, '2026-04-11 16:44:57', '2026-04-11 16:44:57', NULL),
(728, 'Neuracalm 150mg Pregabalin 3x10Caps(West-Coast Pharma Works Ltd)', 'Pregabalin', '150mg', NULL, '(West-Coast Pharma Works Ltd', 'NEURACALM150', 2, 35, 0, NULL, NULL, '2026-04-11 16:52:32', '2026-04-12 16:46:01', NULL),
(729, 'Neurogesic Onitment 35g(DGF)', 'Neurogesic', '35g', NULL, 'DGF', '6156000081335', 2, 10, 0, NULL, NULL, '2026-04-11 16:59:52', '2026-04-11 16:59:52', NULL),
(730, 'Neurogesic Cream 85g(DGF)', 'Neurogesic', '85g', NULL, 'DGF', '6156000081342', 2, 10, 0, NULL, NULL, '2026-04-12 07:49:16', '2026-04-12 07:49:16', NULL),
(731, 'Neuracalm 75mg Prebagalin 3x10Tabs(West-Coast Pharma Work Ltd)', 'Prebagalin', '75mg', NULL, 'West-Coast Pharma Works Ltd', 'GC25054', 2, 26, 0, NULL, NULL, '2026-04-12 07:55:51', '2026-04-12 07:55:51', NULL),
(732, 'Nise Plus Syrup 100ml(Jawa)', 'Nise Plus', '100ml', NULL, 'Jawa International Ltd', '6154000056308', 2, 6, 0, NULL, NULL, '2026-04-12 07:59:49', '2026-04-12 07:59:49', NULL),
(733, 'Nizoral Tropical Cream 15g(Janssen)', 'Ketoconazole', '15g', NULL, 'Janssen', 'QAB0900', 2, 4, 0, NULL, NULL, '2026-04-12 08:03:24', '2026-04-12 08:03:24', NULL),
(734, 'Moko Liquid Paraffin 200ml New Healthway', NULL, NULL, NULL, 'New Healthway Co. Ltd.', '6156000058849', 2, 7, 0, NULL, NULL, '2026-04-12 08:04:06', '2026-04-12 08:04:06', NULL),
(735, 'No-Ach 2x10Tabs(Pharma Ethics Ltd)', 'No-Ach(Aceclofenac & Paracetamol)', NULL, NULL, 'Pharma Ethics Ltd', '8904210707259', 2, 10, 0, NULL, NULL, '2026-04-12 08:07:59', '2026-04-12 08:07:59', NULL),
(736, 'Lodium Loperamide 2mg 10x10 Caps Vixa Pharma /Card', NULL, '2mg', 'capsule', 'Vixa Pharma. Co. Ltd.', '6971161600245', 2, 7, 0, NULL, NULL, '2026-04-12 08:09:52', '2026-04-12 08:09:52', NULL),
(737, 'Misopt Eye Drops Dorzolamide 2% & Timolol 0.5% 5ml Micro Lab', NULL, NULL, 'drops', 'Micro Labs. Ltd.', 'MISOPT-5ML', 2, 13, 0, NULL, NULL, '2026-04-12 08:13:38', '2026-04-12 08:13:38', NULL),
(738, 'Nocof Drops 15ml(Afrab)', 'Paracetamol', '15ml', NULL, 'Afrab', '6154000240486', 2, 6, 0, NULL, NULL, '2026-04-12 08:15:42', '2026-04-12 08:15:42', NULL),
(739, 'Montiget Montelukast Sodium 4mg 4x7 Chewable tabs Getz /Card', NULL, '4mg', 'tablet', 'Getz Pharma', 'MONTIGET-4MG', 2, 6, 0, NULL, NULL, '2026-04-12 08:17:42', '2026-04-12 08:17:42', NULL),
(740, 'Noww-Noww Balm 25g (Jawa)', 'Balm', NULL, NULL, 'Jawa', '6154000056346', 2, 10, 0, NULL, NULL, '2026-04-12 08:17:59', '2026-04-12 08:17:59', NULL),
(741, 'Omega-H3 Bio-Tonic Capsules x5Caps(Vitabiotics)', 'Blood Builder', NULL, NULL, 'Vitabiotics', '5021265254620', 2, 9, 0, NULL, NULL, '2026-04-12 08:21:43', '2026-04-12 08:21:43', NULL),
(742, 'Montiget Montelukast Sodium 10mg 4x7 Chewable tabs Getz /Card', NULL, '10mg', 'tablet', 'Getz Pharma.', 'MONTIGET-10MG', 2, 6, 0, NULL, NULL, '2026-04-12 08:22:49', '2026-04-12 08:22:49', NULL),
(743, 'M&B Nifedipine XL 30mg 3x10tabs May & Baker /Card', NULL, '30mg', 'tablet', 'May & Baker Nig. Plc.', 'M&B-NIFEDIPINE-30MG', 2, 23, 0, NULL, NULL, '2026-04-12 08:27:48', '2026-04-12 08:27:48', NULL),
(744, 'Omit 20mg Omeprazole 2x7Caps(MicroLab)', 'Omeprazole', '20mg', NULL, 'MicroLab', 'OMWH0104', 2, 7, 0, NULL, NULL, '2026-04-12 08:28:07', '2026-04-12 08:28:07', NULL),
(745, 'Pinnacle ORS x3(Pinnacle Health Pharma & Store Ltd)', 'ORS', '20.5gm', NULL, 'Pinnacle Health & Store Ltd', '25GP0166', 2, 7, 0, NULL, NULL, '2026-04-12 08:33:09', '2026-04-12 08:33:09', NULL),
(746, 'Odizat Amlodipine 5mg + Valsartan 160mg 3x10 tabs Bezik /Card', NULL, '5mg/160mg', 'tablet', 'Avantika Medex Pvt. Ltd.', '8906140361938', 2, 23, 0, NULL, NULL, '2026-04-12 08:36:00', '2026-04-12 08:36:00', NULL),
(747, 'P-Alaxin TS 1x3Tabs(Bliss Gvs Pharma Ltd)', 'P-Alaxin', NULL, NULL, 'Bliss Gvs Pharma Ltd', 'D1AW032', 2, 20, 0, NULL, NULL, '2026-04-12 08:36:45', '2026-04-12 08:36:45', NULL),
(748, 'M&B Paracetamol Syrup 60ml(M&B)', 'Paracetamol', '60ml', NULL, 'M&B Pharma Ltd', '6151006000236', 2, 10, 0, NULL, NULL, '2026-04-12 08:40:31', '2026-04-12 08:40:31', NULL),
(749, 'Panda Paracetamol Drops 15ml(Afrab)', 'Paracetamol', '15ml', NULL, 'Afrab-Chem Ltd', '6154000240127', 2, 10, 0, NULL, NULL, '2026-04-12 08:42:08', '2026-04-12 08:42:08', NULL),
(750, 'Peptikit 7x6 Blisters(Geneith Pharma Ltd)', 'Peptikit', NULL, NULL, 'Geneith Pharma Ltd', '251120', 2, 7, 0, NULL, NULL, '2026-04-12 08:46:47', '2026-04-12 08:46:47', NULL),
(751, 'Piriton Syrup 60ml(Evans Baroque Ltd)', 'Piriton', '60ml', NULL, 'Evans baroque Ltd)', '6153400151811', 2, 6, 0, NULL, NULL, '2026-04-12 08:48:41', '2026-04-12 08:48:41', NULL),
(752, 'Oxyurea Hydroxyurea 500mg 3x10 Caps (Bond Chenical)  /Card', NULL, '500mg', 'capsule', 'Bond Chemical Ind. Ltd.', 'OXYUREA-500MG', 2, NULL, 0, NULL, NULL, '2026-04-12 08:49:04', '2026-04-12 08:49:04', NULL),
(753, 'Piriton Expectorant Syrup 100ml(Evans Baroque Ltd)', 'Piriton', '100ml', NULL, 'Evans Baroque Ltd', '6152110046868', 2, 11, 0, NULL, NULL, '2026-04-12 08:52:35', '2026-04-12 08:52:35', NULL),
(754, 'Penicillin Ophthalmic (Eye) Ointment 5g Drugfield', NULL, NULL, 'ointment', 'Drugfield Pharma. Ltd.', 'PENICILLIN-5G', 2, 13, 0, NULL, NULL, '2026-04-12 08:54:56', '2026-04-12 08:54:56', NULL),
(755, 'Piriton Expectorant Syrup (for Children)100ml (Evans Baroque Ltd', 'Piriton', '100ml', NULL, 'Evans Baroque Ltd', '6152110046882', 2, 11, 0, NULL, NULL, '2026-04-12 08:55:11', '2026-04-12 08:55:11', NULL),
(756, 'Piscof Expectorant 100ml(Peace Standard Pharma Ind. Ltd)', 'Piscof', NULL, NULL, 'Peace Standard Pharma Ind. Ltd', 'PCF2643', 2, 11, 0, NULL, NULL, '2026-04-12 09:01:01', '2026-04-12 09:01:01', NULL),
(757, 'Oplex Antitussive & Expectorant Syrup 125ml(Amriva Pharma Indu.)', 'Oplex', '125ml', NULL, 'Amriva Pharma Indu', '100845', 2, 11, 0, NULL, NULL, '2026-04-12 09:07:09', '2026-04-12 09:07:09', NULL),
(758, 'Piloma Pilocarpine 4% Sterile Eye Drops Opsonin Pharma.', NULL, NULL, 'drops', 'Opsonin Pharma Ltd.', 'PILOMA-4PERCENT', 2, 13, 0, NULL, NULL, '2026-04-12 09:11:11', '2026-04-12 09:11:11', NULL),
(759, 'Agary Pregnancy Test Strips x50Strips(Agary Pharma Ltd)', 'Pregnancy Strip', NULL, NULL, 'Agary Pharma Ltd', '6937579901015', 2, 5, 0, NULL, NULL, '2026-04-12 09:11:14', '2026-04-12 09:11:14', NULL),
(760, 'Piloma Pilocarpine 2% Sterile Eye Drops Opsonin Pharma.', NULL, NULL, 'drops', 'Opsomin Pharma Ltd.', 'PILOMA-2PERCENT', 2, 13, 0, NULL, NULL, '2026-04-12 09:15:17', '2026-04-12 09:15:17', NULL),
(761, 'Prexam Tranexamic acid 500mg 2x10Caps West-Coast Pharma. /Card', NULL, '500mg', 'capsule', 'West-Coast Pharma. Works Ltd.', 'PREXAM-CAPS-500MG', 2, 10, 0, NULL, NULL, '2026-04-12 09:20:26', '2026-04-12 09:20:26', NULL),
(762, 'Tenoric Atenolol 100mg & Chlortalidone 25mg 2x14tabs Ipca /Card', NULL, '100mg/25mg', 'tablet', 'Ipca Laboratories Ltd.', '8901079006189', 2, 23, 0, NULL, NULL, '2026-04-12 09:24:22', '2026-04-12 09:24:22', NULL),
(763, 'Tenoric-50 Atenolol 50mg & Chlortalidone 12.5mg 2x14tabs Ipca /Card', NULL, '50mg/12.5mg', NULL, 'Ipca Laboratories Ltd.', '8901079006172', 2, 23, 0, NULL, NULL, '2026-04-12 09:28:17', '2026-04-12 09:28:17', NULL),
(764, 'Valvas Amlodipine 5mg & Valsartan 160mg 3x10tabs Popular /Card', NULL, '5mg/160mg', 'tablet', 'Popular Pharma. Ltd.', 'VALVAS-5/160', 2, 23, 0, NULL, NULL, '2026-04-12 09:34:52', '2026-04-12 09:34:52', NULL),
(765, 'Valsartil Valsartan 80mg 3x10tabs Incepta Pharma. Ltd /Card', NULL, '80mg', 'tablet', 'Incepta Pharma. Ltd.', 'VALSARTIL-80MG', 2, 23, 0, NULL, NULL, '2026-04-12 09:41:31', '2026-04-12 09:41:31', NULL),
(766, 'Valsartil Valsartan 160mg 3x10tabs Incepta Pharma. Ltd /Card', NULL, '160mg', 'tablet', 'Incepta Pharma. Ltd.', 'VALSARTIL-160MG', 2, 23, 0, NULL, NULL, '2026-04-12 09:45:39', '2026-04-12 09:45:39', NULL),
(767, 'Valvas HCT Amlodipine/Valsartan/Hydro 10/160/12.5mg 4x7tabs Popular /Card', NULL, '10mg/160mg/12.5mg', 'tablet', 'Popular Pharma. Ltd.', 'VALVASHCT-10/160/12.5', 2, 23, 0, NULL, NULL, '2026-04-12 09:52:49', '2026-04-12 09:53:31', NULL),
(768, 'Valvas HCT Amlodipine/Valsartan/Hydro 10/160/25mg 4x7tabs Popular /Card', NULL, '10mg/160mg/25mg', 'tablet', 'Popular Pharma. Ltd.', 'VALVASHCT-10/160/25', 2, 23, 0, NULL, NULL, '2026-04-12 09:57:33', '2026-04-12 09:57:33', NULL),
(769, 'Aquapress Sterilised Water For Injection 50x10ml Pyrogen Free /Vial', NULL, NULL, 'injection', 'Protech Biosystems Pvt. Ltd.', 'AQUAPRESS-50X10ML', 2, 5, 0, NULL, NULL, '2026-04-12 10:03:17', '2026-04-12 10:03:17', NULL),
(770, 'Penicillin Ointment 10,000IU 20g(DGF)', 'Penicillin', '20g', NULL, 'DGF', '01M0229', 2, 8, 0, NULL, NULL, '2026-04-12 10:07:54', '2026-04-12 10:07:54', NULL),
(771, 'Xonadine Fexofenadine Hydro 120mg 10tabs Micro lab', NULL, '120mg', 'tablet', 'Micro Labs Ltd.', 'XONADINE-120MG', 2, 6, 0, NULL, NULL, '2026-04-12 10:08:48', '2026-04-12 10:08:48', NULL),
(772, 'Xonadine Fexofenadine Hydro 180mg 10tabs Micro lab', NULL, '180mg', 'tablet', 'Micro Labs. Ltd.', 'XONADINE-180MG', 2, 6, 0, NULL, NULL, '2026-04-12 10:13:03', '2026-04-12 10:13:03', NULL),
(773, 'Ratin-A Plus Tretinoin Cream 0.1% 30g(Merit Organic Ltd/Praipec Pharma Ltd)', 'Tretinoin', '30g', NULL, 'Merit Organic Ltd/Praipec Pharma Ltd', 'E11801', 2, 6, 0, NULL, NULL, '2026-04-12 10:15:52', '2026-04-12 10:15:52', NULL),
(774, 'Menthodex Cough Mixture 100ml Bells, Sons & Co. UK', NULL, NULL, 'syrup', 'Bell, Sons & Co.', '5017848248032', 2, 23, 0, NULL, NULL, '2026-04-12 10:19:02', '2026-04-12 10:19:02', NULL),
(775, 'Acycor 100mg Aceclofenac 1x10Tabs(Reals Specialties Ltd)', 'Aceclofenac', '100mg', NULL, 'Reals Specialties Ltd', 'ACYCOR-100MG', 2, 10, 0, NULL, NULL, '2026-04-12 10:20:35', '2026-04-12 14:09:20', NULL),
(776, 'Coflin Cough Linctus Syrup 100ml (Vitabiotic)', NULL, NULL, 'syrup', 'Vitabiotics Ltd', 'COFLIN-LINCTUS', 2, 11, 0, NULL, NULL, '2026-04-12 10:25:52', '2026-04-12 10:25:52', NULL),
(777, 'Reludrine 100mg Proguanil 10x10Tabs(Reals Pharma Ltd/Aquatic Remedies Ltd)', 'Proguanil', '100mg', NULL, 'Reals Pharma Ltd', 'AF60507', 2, 26, 0, NULL, NULL, '2026-04-12 10:27:31', '2026-04-12 10:27:31', NULL),
(778, 'Dele Absorbent Cotton Wool Hydrophilic 500g', NULL, NULL, NULL, 'Ayo-Ayodele Pharma. Chemist Nig. Ltd.', '6157000589272', 2, 5, 0, NULL, NULL, '2026-04-12 10:29:49', '2026-04-12 10:29:49', NULL),
(779, 'Relev 500mg Naproxen x20Tabs(', 'Naproxen', '500mg', NULL, NULL, 'RELEV500', 2, 10, 0, NULL, NULL, '2026-04-12 10:30:07', '2026-04-12 16:52:32', NULL),
(780, 'Relev 500mg Naproxen 2x10Tabs(Swipha)', 'Naproxen', '500mg', NULL, 'Swipha', 'L225059', 2, 10, 0, NULL, NULL, '2026-04-12 10:33:36', '2026-04-12 10:33:36', NULL),
(781, 'Aventra 5% Dextrose Infusion  500ml Fidson Healthcare Plc.', NULL, NULL, 'injection', 'Fidson Healthcare Plc.', '6034000231588', 2, 5, 0, NULL, NULL, '2026-04-12 10:34:42', '2026-04-12 10:34:42', NULL),
(782, 'Aventra Normal Saline Infusion 500ml Fidson Healthcare', NULL, NULL, 'injection', 'Fidson Healthcare Plc.', '6034000231632', 2, 5, 0, NULL, NULL, '2026-04-12 10:38:18', '2026-04-12 10:38:18', NULL),
(783, 'Robinax 500mg Methocarbamol 1x10Tabs(Khandewal Labora. Pvt Ltd)', 'Robinax', '500mg', NULL, 'Khandewal Labora. Pvt Ltd', 'UTGRBA501', 2, 10, 0, NULL, NULL, '2026-04-12 10:39:51', '2026-04-12 10:39:51', NULL),
(784, 'Aventra 5% Dextrose & Saline Infusion 500ml Fidson Healthcare', NULL, NULL, 'injection', 'Fidson Healthcare Plc.', '6034000231601', 2, 5, 0, NULL, NULL, '2026-04-12 10:41:30', '2026-04-12 10:41:30', NULL),
(785, 'Ascochew Vitamin C White x100Tabs(Diamond Healthcare Ltd)', 'Vitamin', '100mg', NULL, 'Diamond Healthcare Ltd', '1193153852325', 2, 12, 0, NULL, NULL, '2026-04-12 10:42:18', '2026-04-12 10:42:18', NULL),
(786, 'Gestid Tasty Chewable Antacid 20tabs Sun Pharma.', NULL, NULL, 'tablet', 'Sun Pharma. ind. Ltd.', '8901296107515', 2, 7, 0, NULL, NULL, '2026-04-12 10:45:42', '2026-04-12 10:45:42', NULL),
(787, 'Omeprazole 20mg 3x10Caps(Swipha)', 'Omeprazole', '20mg', NULL, 'Swipha', 'OMZ165', 2, 7, 0, NULL, NULL, '2026-04-12 10:46:40', '2026-04-12 10:46:40', NULL),
(788, 'MarkLint Medical Wool Absorbent Cotton Pleat 50g', NULL, NULL, NULL, 'Marklint Medical Complex Ltd.', 'MARKLINT-50G', 2, 5, 0, NULL, NULL, '2026-04-12 10:49:53', '2026-04-12 10:51:51', NULL),
(789, 'Swidar 500/25mg 1x3Tabs(Swipha)', 'Swidar', '500/25', NULL, 'Swipha', 'L223081', 2, 20, 0, NULL, NULL, '2026-04-12 10:50:24', '2026-04-12 10:50:24', NULL),
(790, 'MarkLint Medical Wool Absorbent Cotton Pleat 100g', NULL, NULL, NULL, 'Marklint Medical Complex Ltd.', 'MARKLINT-100G', 2, 5, 0, NULL, NULL, '2026-04-12 10:53:32', '2026-04-12 10:53:32', NULL),
(791, 'Baby Tribotan Cream 20g(Fidson)', 'Tribotan', '20g', NULL, 'Fidson', '6154000373528', 2, 6, 0, NULL, NULL, '2026-04-12 10:54:29', '2026-04-12 10:54:29', NULL),
(792, 'Ndusco Absorbent Cotton Wool Super Quality 100g', NULL, NULL, NULL, 'Ndusco Ventures Ltd.', 'NDUSCO-WOOL100G', 2, 5, 0, NULL, NULL, '2026-04-12 10:57:20', '2026-04-12 10:57:20', NULL),
(793, 'Clofenac SR 100mg Diclofenac 10x10Tabs(Hovid)', 'Diclofenac', NULL, NULL, 'Hovid', 'UCLO131', 2, 10, 0, NULL, NULL, '2026-04-12 10:57:36', '2026-04-12 10:57:36', NULL),
(794, 'Clofenac 50mg Diclofenac 10x10Tabs(Hovid)', 'Diclofenac', '50mg', NULL, 'Hovid', 'UCLO126', 2, 10, 0, NULL, NULL, '2026-04-12 11:00:20', '2026-04-12 11:00:20', NULL),
(795, 'Coloseal Loperamide 2mg 10x10 Caps Hovid /Card', NULL, '2mg', 'capsule', 'Hovid Berhad', 'UCOL43', 2, 7, 0, NULL, NULL, '2026-04-12 11:03:28', '2026-04-12 11:03:28', NULL),
(796, 'Dopatab M250 Methyldopa 10x10Tabs(Hovid)', 'Methyldopa', '250mg', NULL, 'Hovid', 'UDOP15', 2, 23, 0, NULL, NULL, '2026-04-12 11:05:35', '2026-04-12 11:05:35', NULL),
(797, 'Daravit Woman Combipack Product Multivitamin Elbe', NULL, NULL, 'capsule', 'Elbe Pharma Nig. Ltd.', '714084877563', 2, 12, 0, NULL, NULL, '2026-04-12 11:08:29', '2026-04-12 11:08:29', NULL),
(798, 'Felxicam 20mg Proxicam 10x10Caps(Hovid)', 'Proxicam', '20mg', NULL, 'Hovid', 'UFEL20', 2, 10, 0, NULL, NULL, '2026-04-12 11:09:08', '2026-04-12 11:09:08', NULL),
(799, 'Vasoprin Caedio Protective 75mg 10x10Tabs(Juhel Nig. Ltd)', 'Vasoprin', '75mg', NULL, 'Juhel Nig. Ltd', '6156000045627', 2, 23, 0, NULL, NULL, '2026-04-12 11:13:26', '2026-04-12 11:13:26', NULL),
(800, 'Visita Plus Cream 30g(Elbe Pharma Ltd)', 'Visita', '30g', NULL, 'Elbe Pharma Ltd', '714084870779', 2, 8, 0, NULL, NULL, '2026-04-12 11:16:49', '2026-04-12 11:16:49', NULL),
(801, 'Daravit Omega H6 Bioactive Omega 3,6,9 3x10Caps Elbe /Card', NULL, NULL, 'capsule', 'Elbe Pharma.', '714084870823', 2, 12, 0, NULL, NULL, '2026-04-12 11:17:49', '2026-04-12 11:17:49', NULL),
(802, 'Whitfield Ointment 20g(DGF)', 'Whitfield', '20g', NULL, 'DGF', '6156000081304', 2, 8, 0, NULL, NULL, '2026-04-12 11:20:39', '2026-04-12 11:20:39', NULL),
(803, 'Amatem Artemether/Lumefantrine 20mg/120mg 18 Softgel Elbe', NULL, '20mg/120mg', 'capsule', 'Elbe Pharma Nig. Ltd.', 'AMATEM-18', 2, 20, 0, NULL, NULL, '2026-04-12 11:24:19', '2026-04-18 14:09:44', NULL),
(804, 'Wosan 5% Povidone-Iodine Ointment 20g(Jawa)', 'Povidone-Iodine', '20g', NULL, 'Jawa', '6154000056506', 2, 33, 0, NULL, NULL, '2026-04-12 11:25:05', '2026-04-12 11:25:05', NULL),
(805, 'Obron-6 Multivitamin Plus Iron 5x6 Capsules Neimeth /Card', NULL, NULL, 'capsule', 'Neimeth International Pharma. Ltd.', '6156000084442', 2, 12, 0, NULL, NULL, '2026-04-12 11:28:48', '2026-04-12 11:28:48', NULL),
(806, 'Yeast x100Tabs(Biopharma Nig. Ltd)', 'Yeast', NULL, NULL, 'Biopharma Nig. Ltd', 'BYT072D', 2, 12, 0, NULL, NULL, '2026-04-12 11:30:03', '2026-04-12 11:30:03', NULL),
(807, 'De-Deon\'s Syrup of Haemoglobin Vitamin B12 280ml', NULL, NULL, 'syrup', 'Daily-Need Industries Limited', '6156000006512', 2, 9, 0, NULL, NULL, '2026-04-12 11:32:51', '2026-04-12 11:32:51', NULL),
(808, 'Zerodol 100mg Aceclofenac 1x10Tabs(Ipca laborat. Ltd)', 'Aceclofenac', NULL, NULL, 'Ipca laborat. Ltd)', '8901079006967', 2, 10, 0, NULL, NULL, '2026-04-12 11:34:31', '2026-04-12 11:34:31', NULL),
(809, 'Chi Alieve Ibuprofen 100mg/5ml Oral Suspension 100ml', NULL, '100mg', 'syrup', 'Chi Pharma. Ltd.', '152000507943', 2, 10, 0, NULL, NULL, '2026-04-12 11:39:17', '2026-04-12 11:39:17', NULL),
(810, 'Drovid 400mg Ofloxacin x10Tabs(Tyonex Nig. Ltd)', 'Ofloxacin', '400mg', NULL, 'Tyonex nig. Ltd', 'DRD004L', 2, 8, 0, NULL, NULL, '2026-04-12 11:42:55', '2026-04-12 11:42:55', NULL),
(811, 'Benylin Original Effective Cough Relief Syrup Age 6+ 100ml', NULL, NULL, 'syrup', 'Johnson & Johnson', '6001135505433', 2, 11, 0, NULL, NULL, '2026-04-12 11:43:07', '2026-04-12 11:43:07', NULL);
INSERT INTO `drugs` (`id`, `brand_name`, `generic_name`, `strength`, `dosage_form`, `manufacturer`, `barcode`, `category_id`, `subcategory_id`, `is_prescription_only`, `controlled_substance_class`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(812, 'Forcept', 'Forcept', NULL, NULL, NULL, 'FORCEPT141', 2, 5, 0, NULL, NULL, '2026-04-12 11:46:04', '2026-04-12 11:46:04', NULL),
(813, 'Gold Circle 3 Lubricated Natural Rubber latex Condoms SFH', NULL, NULL, NULL, 'Karex Industries Sdn Bhd', '00050024200016GC', 2, 17, 0, NULL, NULL, '2026-04-12 11:51:49', '2026-04-12 11:51:49', NULL),
(814, 'Ginsomin 3x10Softgel Caps(Mega Lifescience Nig. Ltd)', 'Vitamin', NULL, NULL, 'Mega Lifesciences Nig. Ltd', '8850769005103', 2, 12, 0, NULL, NULL, '2026-04-12 11:57:02', '2026-04-12 11:57:02', NULL),
(815, 'Camosunate Powder (Paediatric Below 1 Year) (Geneith Pharma Ltd)', NULL, '75mg/25mg', NULL, 'Geneith Pharma Ltd', '6928623000358', 2, 20, 0, NULL, NULL, '2026-04-12 11:58:47', '2026-04-12 11:58:47', NULL),
(816, 'Rexall Paracetamol 125mg Suppositories 2x5 Supp /Card', NULL, '125mg', NULL, 'Daily-Need industries Ltd.', '6156000154640', 2, 10, 0, NULL, NULL, '2026-04-12 12:03:00', '2026-04-12 12:03:00', NULL),
(817, 'Gripe Water Woodward\'s 148ml(SKG)', 'Gripe Water', '148ml', NULL, 'SKG', '608887011401', 2, 34, 0, NULL, NULL, '2026-04-12 12:03:10', '2026-04-12 12:03:10', NULL),
(818, 'Gripe Water Woodward\'s 100ml(SKG)', 'Gripe Water', '100ml', NULL, 'SKG', '608887011395', 2, 34, 0, NULL, NULL, '2026-04-12 12:05:10', '2026-04-12 12:24:14', NULL),
(819, 'Durex Fetherlite Regular Fit 12 Condoms Preservativos', NULL, NULL, NULL, NULL, '5038483579930', 2, 17, 0, NULL, NULL, '2026-04-12 12:06:47', '2026-04-12 12:06:47', NULL),
(820, 'Accu-Chek Active Machine Roche', NULL, NULL, NULL, NULL, '4015630085835', 2, 5, 0, NULL, NULL, '2026-04-12 12:13:34', '2026-04-12 12:13:34', NULL),
(821, 'Em-B-Plex Vitamin B Complex 1000 tabs Emzor /Tab', NULL, NULL, 'tablet', 'Emzor Pharma. Industries Ltd.', '6154000033309', 2, 12, 0, NULL, NULL, '2026-04-12 12:21:46', '2026-04-12 12:21:46', NULL),
(822, 'Jinja Herbal Extracts 350ml(Multistream Ltd)', 'Herbal Extract', '350ml', NULL, 'Multistream Ltd', '8266972287500', 2, 12, 0, NULL, NULL, '2026-04-12 12:29:48', '2026-04-12 12:29:48', NULL),
(823, 'Omefast Plus Combi Kit Clarith 250mg Omepra 20mg tinidazole 500mg', NULL, '250mg/20mg/500mg', NULL, 'McW Healthcare (P) Ltd.', 'OMEFAST-PLUS', 2, 7, 0, NULL, NULL, '2026-04-12 12:33:07', '2026-04-12 12:35:29', NULL),
(824, 'Kiptrack Blood Glucose Test Strips *Per One (Dual Pack)(RapidCheck Diagnostics & Wellness Ltd)', 'Blood Glucose Strip', NULL, NULL, 'RapidCheck Diagnostics & Wellness Ltd', '4717095032866', 2, 5, 0, NULL, NULL, '2026-04-12 12:36:59', '2026-04-17 13:17:51', NULL),
(825, 'Kofol Herbal Syrup 100ml(Charak Pharma Pvt Ltd', 'Herbal Syrup', '100ml', NULL, 'Charak Pharma Pvt Ltd', '8901082000013', 2, 11, 0, NULL, NULL, '2026-04-12 12:41:15', '2026-04-12 12:41:15', NULL),
(826, 'Durex Extra Safe 12 Condoms Preservativos', NULL, NULL, NULL, NULL, '5010232967465', 2, 17, 0, NULL, NULL, '2026-04-12 12:42:50', '2026-04-12 12:42:50', NULL),
(827, 'Talen 3mg Bromazepam 3x10Tabs(Swipha)', 'Bromazepam', '3mg', NULL, 'Swipha', 'L225078', 2, 36, 0, NULL, NULL, '2026-04-12 12:46:35', '2026-04-12 12:46:35', NULL),
(828, 'Trojan BareSkin 3 Lubricated Latex Condoms', NULL, NULL, NULL, NULL, '022600957058', 2, 17, 0, NULL, NULL, '2026-04-12 12:46:39', '2026-04-12 12:46:39', NULL),
(829, 'KY Personal Lubricant Jelly 50g', NULL, NULL, NULL, NULL, '6970960010453', 2, 17, 0, NULL, NULL, '2026-04-12 12:50:44', '2026-04-12 12:50:44', NULL),
(830, 'Lokmal QS-Combi x6Tabs(Emzor Pharma Indus. Ltd)', 'Lokmal', NULL, NULL, 'Emzor Pharma Indu. Ltd', '6154000033873', 2, 20, 0, NULL, NULL, '2026-04-12 12:50:46', '2026-04-12 12:50:46', NULL),
(831, 'Calgovit 20 Effervescent tabs Vitamin C 1000mg Sugar Free', NULL, '1000mg', 'tablet', NULL, '3800048207419', 2, 12, 0, NULL, NULL, '2026-04-12 12:54:21', '2026-04-12 12:54:21', NULL),
(832, 'Longrich Toothpaste 200g', 'Toothpaste', '200g', NULL, 'Longrich', '6945573601039', 2, 18, 0, NULL, NULL, '2026-04-12 12:56:37', '2026-04-12 12:56:37', NULL),
(833, 'Trojan Magnum Ecstasy 3 Latex Condoms', NULL, NULL, NULL, NULL, '022600647201', 2, 17, 0, NULL, NULL, '2026-04-12 12:58:09', '2026-04-12 12:58:09', NULL),
(834, 'M2-Tone Herbal Tablet(Charak Pharma Pvt Ltd)', 'Herbal', NULL, NULL, 'Charak Pharma Pvt Ltd', '8901082005506', 2, 12, 0, NULL, NULL, '2026-04-12 13:01:46', '2026-04-12 13:01:46', NULL),
(835, 'Durex Mutual Climax Regular Fit 3 Condoms', NULL, NULL, NULL, NULL, '6151100281845', 2, 17, 0, NULL, NULL, '2026-04-12 13:01:52', '2026-04-12 13:01:52', NULL),
(836, 'Trojan Magnum Large Size 3 Latex Condoms', NULL, NULL, NULL, NULL, '022600642039', 2, 17, 0, NULL, NULL, '2026-04-12 13:05:19', '2026-04-12 13:05:19', NULL),
(837, 'Magnesium Glycinate 400mg x90Tabs(Nature\'sField)', 'Vitamin', '400mg', NULL, 'Nature\'sField', '698746728458', 2, 12, 0, NULL, NULL, '2026-04-12 13:08:39', '2026-04-12 13:08:39', NULL),
(838, 'Emcap Paracetamol Suspension 120mg/5ml 60ml Emzor', NULL, '120mg', 'syrup', 'Emzor Pharma. Industries Ltd.', '6154000033064', 2, 10, 0, NULL, NULL, '2026-04-12 13:09:50', '2026-04-12 13:09:50', NULL),
(839, 'Melatonin 5mg x60Tabs(Mason Natural)', 'Vitamin', '5mg', NULL, 'Mason Natural', '311845111456', 2, 12, 0, NULL, NULL, '2026-04-12 13:11:23', '2026-04-12 13:11:23', NULL),
(840, 'Esofag-Kit 7 x 1 kit Amoxi 1000mg Clarith 500mg Esome 20mg Micro Lab', NULL, '1000mg/500mg/20mg', NULL, 'Micro Labs Ltd.', 'ESOFAG-KIT', 2, 7, 0, NULL, NULL, '2026-04-12 13:14:56', '2026-04-12 13:15:31', NULL),
(841, 'Meditrol 0.25mcg Calcitriol 3x10 Softgel(Mega LifeSciences Nig. Ltd)', 'Calcitriol', '0.25mcg', NULL, 'Mega LifeSciences Nig. Ltd', '8850769027167', 2, 12, 0, NULL, NULL, '2026-04-12 13:15:35', '2026-04-12 13:15:35', NULL),
(842, 'Vigor Chocolate For Men +18  /pack', NULL, NULL, NULL, NULL, '8692621810025', 2, 17, 0, NULL, NULL, '2026-04-12 13:19:27', '2026-04-12 13:19:27', NULL),
(843, 'Mifepak x5Tabs(DKT International Nig.)', 'Mifepak', NULL, NULL, 'DKT International Nig', '8906088660193', 2, 21, 0, NULL, NULL, '2026-04-12 13:22:06', '2026-04-12 13:22:06', NULL),
(844, 'Corsodyl Chlorhexidine 0.2% Alcohol Free Mint Flavour Mouthwash 300ml', NULL, NULL, NULL, 'Haleon UK Trading Ltd.', '5000347037689', 2, 1, 0, NULL, NULL, '2026-04-12 13:24:18', '2026-04-12 13:24:18', NULL),
(845, 'Moko Mist. Pot.Cit 200ml(New Healthway Co. Ltd)', 'Mist Pot.Cit', '200ml', NULL, 'New Healthway Co. Ltd', '6156000058825', 2, 30, 0, NULL, NULL, '2026-04-12 13:26:05', '2026-04-12 13:26:05', NULL),
(846, 'Durex Pleasure Me Regular Fit 3 Condoms Preservativos', NULL, NULL, NULL, NULL, '6001106225421', 2, 17, 0, NULL, NULL, '2026-04-12 13:27:22', '2026-04-12 13:27:22', NULL),
(847, 'Durex Select Fruity Flavours For Extra Fun 3 Condoms', NULL, NULL, NULL, NULL, '6151100281128', 2, 17, 0, NULL, NULL, '2026-04-12 13:29:48', '2026-04-12 13:29:48', NULL),
(848, 'Durex Perfoma Regular Fit 3 Condoms Preservativos', NULL, NULL, NULL, NULL, '5010232953925', 2, 17, 0, NULL, NULL, '2026-04-12 13:42:55', '2026-04-12 13:42:55', NULL),
(849, 'On Call Plus II Blood Glucose Strips(Acon Laborate Inc.)', 'Glucose Strip', NULL, NULL, 'Acon Laborat. Inc', '1293197', 2, 5, 0, NULL, NULL, '2026-04-12 13:44:18', '2026-04-12 13:44:18', NULL),
(850, 'Durex Fetherlite Regular Fit 3 Condoms Preservativos', NULL, NULL, NULL, NULL, '5010232953994', 2, 17, 0, NULL, NULL, '2026-04-12 13:45:18', '2026-04-12 13:47:16', NULL),
(851, 'Dr. Meyer\'s Orheptal Elixir 300ml(Farmex Meyer Ltd)', 'Blood Builder', '300ml', NULL, 'Farmex Meyer Ltd', '6154000273262', 2, 9, 0, NULL, NULL, '2026-04-12 13:48:02', '2026-04-12 13:48:02', NULL),
(852, 'Amitriptyline Hydro 25mg 10tabs Chez Resources Pharma.', NULL, '25mg', 'tablet', 'West-Coast Pharma. Works Ltd.', '8904278598868', 2, 25, 0, NULL, NULL, '2026-04-12 13:49:47', '2026-04-12 13:49:47', NULL),
(853, 'Ecoslim 120mg Orlistat 1x21Caps(MicroLabs Indu Ltd)', 'Orlistat', '120mg', NULL, 'MicroLabs Indu Ltd', 'ECSY0065', 2, 12, 0, NULL, NULL, '2026-04-12 13:52:05', '2026-04-12 13:52:05', NULL),
(854, 'Salonpas Pain Relieving Jet Spray 118ml Hisamitsu', NULL, NULL, NULL, 'Hisamitsu Pharma Co. , Inc', '4987188511329', 2, 10, 0, NULL, NULL, '2026-04-12 13:52:47', '2026-04-12 13:52:47', NULL),
(855, 'Panadol Night x24Tabs(GSK)', 'Panadol', '500mg', NULL, 'GSK', '6291109120674', 2, 10, 0, NULL, NULL, '2026-04-12 13:53:36', '2026-04-12 13:53:36', NULL),
(856, 'Anudol Suppositories 4 Way Action 2x6 Supp  /Card', NULL, NULL, NULL, 'Daily-Need Industries Ltd.', '6156000154619', 2, 33, 0, NULL, NULL, '2026-04-12 13:56:37', '2026-04-12 13:56:58', NULL),
(857, 'Pentazocine Inject 30mg/10x1ml(Zolon Healthcare Ltd)', 'Pentazocine', '30mg', NULL, 'Zolon Healthcare Ltd', '8905013009861', 2, 10, 0, NULL, NULL, '2026-04-12 13:58:37', '2026-04-12 13:58:37', NULL),
(858, 'Piriton Allergy x30Tabs(Haleon UK)', 'Piriton', NULL, NULL, 'Haleon UK', '5054563076281', 2, 6, 0, NULL, NULL, '2026-04-12 14:01:26', '2026-04-12 14:01:26', NULL),
(859, 'Evergreen Folic Acid + Vitamin B12 120tabs', NULL, NULL, 'tablet', NULL, '6156000081229', 2, 12, 0, NULL, NULL, '2026-04-12 14:04:41', '2026-04-12 14:06:39', NULL),
(860, 'Podophyllin 0.15% Cream 20g(Kwality Pharma Ltd)', 'Podophyllin', '20gm', NULL, 'Kwality Pharma Ltd', 'A433', 2, 6, 0, NULL, NULL, '2026-04-12 14:05:18', '2026-04-12 14:05:18', NULL),
(861, 'Primolut-N 5mg Norethisterone x30Tabs(Bayer)', 'Primolut-N', '5mg', NULL, 'Bayer', '4008500060070', 2, 21, 0, NULL, NULL, '2026-04-12 14:09:08', '2026-04-12 14:09:08', NULL),
(862, 'Procomil Spray 100ml(Walter Ritter Pharma Germany))', 'Procomil', '100ml', NULL, 'Walter Ritter Pharma Germany', '4014852751412', 2, 17, 0, NULL, NULL, '2026-04-12 14:13:25', '2026-04-12 14:13:25', NULL),
(863, 'Purit Antiseptic 125ml', NULL, NULL, NULL, NULL, 'PURIT-125ML', 2, 16, 0, NULL, NULL, '2026-04-12 14:28:04', '2026-04-12 14:28:04', NULL),
(864, 'First Aid Box Green Small Size(U-LifeSciences', 'First Aid', NULL, NULL, 'U-LifeScience', 'FIRST AID', 2, 5, 0, NULL, NULL, '2026-04-12 14:37:12', '2026-04-12 14:37:12', NULL),
(865, 'Ruzu Herbal Bitters 200ml', NULL, NULL, 'syrup', 'Ruzu Herbal Products & Services Ltd.', '726529638592', 2, 12, 0, NULL, NULL, '2026-04-12 14:44:55', '2026-04-12 14:44:55', NULL),
(866, 'Aboniki Balm 25g', 'Aboniki', '25g', NULL, NULL, '6156000046105', 2, 11, 0, NULL, NULL, '2026-04-12 14:45:51', '2026-04-12 14:45:51', NULL),
(867, 'Savlon Antiseptic 75ml Johnson & Johnson', NULL, NULL, NULL, 'Johnson & Johnson', '6003001001858', 2, 16, 0, NULL, NULL, '2026-04-12 14:47:53', '2026-04-12 14:47:53', NULL),
(868, 'Accu-Check Active Strips x50(Roche Diabetes Care Ltd)', 'Accu-Check', NULL, NULL, 'Roche Diabetes Care Ltd', '4015630064007', 2, 5, 0, NULL, NULL, '2026-04-12 14:49:56', '2026-04-12 14:49:56', NULL),
(869, 'Addyzoa Herbal Capsules(Charak Pharma Pvt Ltd)', 'Addyzoa', NULL, NULL, 'Charak Pharma Pvt Ltd', '8901082010562', 2, 12, 0, NULL, NULL, '2026-04-12 14:52:53', '2026-04-12 14:52:53', NULL),
(870, 'Sterile Antibiotic Tulle 10 Dressing Fermycetin Sulphate 10cm x10cm', NULL, NULL, NULL, 'PB Global Industries Ltd.', 'GLOBAL-SOFRATULE', 2, 5, 0, NULL, NULL, '2026-04-12 14:52:57', '2026-04-12 14:55:42', NULL),
(871, 'Amyvil 25mg Amitriptylin Hcl 10x10Tabs(Zolon Healthcare Ltd)', 'Amitriptylin', '25mg', NULL, 'Zolon Healthcare Ltd', '6154000287054', 2, 6, 0, NULL, NULL, '2026-04-12 14:55:45', '2026-04-12 14:55:45', NULL),
(872, 'Amlodipine 10mg 10x10Tabs(Swipha)', 'Amlodipine', '10mg', NULL, 'Swipha', '8906201320058', 2, 23, 0, NULL, NULL, '2026-04-12 15:00:13', '2026-04-12 15:00:13', NULL),
(873, 'Amlodipine 5mg 10x10Tabs(Swipha)', 'Amlodipine', '5mg', NULL, 'Swipha', '8906035500510', 2, 23, 0, NULL, NULL, '2026-04-12 15:02:59', '2026-04-12 15:02:59', NULL),
(874, 'Nature\'s Field Super Calcium 600 + D3 400 100tabs', NULL, NULL, 'tablet', NULL, '713757082303', 2, 12, 0, NULL, NULL, '2026-04-12 15:04:46', '2026-04-12 15:04:46', NULL),
(875, 'Andrews LiverSalts(Lemon Flavour)x50Sachets(GSK)', 'Andrews', NULL, NULL, 'GSK', '6161105660286', 2, 7, 0, NULL, NULL, '2026-04-12 15:06:12', '2026-04-12 15:06:12', NULL),
(876, 'Bragg Apple Cider Vinegar 473ml(Bragg Live Food Products LLC)', 'Herbal', '473ml', NULL, 'Bragg Live Food Products LLC', '074305001161', 2, 12, 0, NULL, NULL, '2026-04-12 15:13:06', '2026-04-12 15:13:06', NULL),
(877, 'Ursoliv Ursodeoxycholic Acid 250mg 5x10 Caps Mega /Card', NULL, '250mg', 'capsule', 'Mega Lifesciences (Australia) PTY. LTD.', '8850769027266', 2, 30, 0, NULL, NULL, '2026-04-12 15:13:30', '2026-04-12 15:13:30', NULL),
(878, 'Bragg Apple Cider Vinegar 946ml(Bragg Live Food Products LLC)', 'Herbal', '946ml', NULL, 'Bragg Live Food Products LLC', '074305001321', 2, 12, 0, NULL, NULL, '2026-04-12 15:14:28', '2026-04-12 15:14:28', NULL),
(879, 'Virest Aciclovir 5% Cream 5g Hovid', NULL, NULL, 'cream', 'Hovid Bhd', 'UVIR18', 2, 37, 0, NULL, NULL, '2026-04-12 15:18:00', '2026-04-12 15:18:00', NULL),
(880, 'Avodart 0.5mg Dutasteride x30Soft Capsule(GSk)', 'Dutasteride', '0.5mg', NULL, 'GSK', '5900008028042', 2, 30, 0, NULL, NULL, '2026-04-12 15:19:18', '2026-04-12 15:19:18', NULL),
(881, 'Nature\'s Field B-6 50mg 100tabs Supplement', NULL, '50mg', 'tablet', NULL, '799872985781', 2, 12, 0, NULL, NULL, '2026-04-12 15:20:36', '2026-04-12 15:20:36', NULL),
(882, 'Bisoprolol Fumarate 5mg x28Tabs(Sandoz)', 'Bisoprolol', '5mg', NULL, 'Sandoz', '5015915917102', 2, 23, 0, NULL, NULL, '2026-04-12 15:28:27', '2026-04-12 15:28:27', NULL),
(883, 'Nature\'s Field Vitamin C 1500mg 60 tabs Supplement Bottle', NULL, '1500mg', 'tablet', NULL, '713757084109', 2, 12, 0, NULL, NULL, '2026-04-12 15:28:50', '2026-04-12 15:28:50', NULL),
(884, 'B-Max High Potency B-Complex x30Tabs(Nature\'s Field)', 'Vitamin', NULL, NULL, 'Nature\'s Field', '799872986863', 2, 12, 0, NULL, NULL, '2026-04-12 15:31:17', '2026-04-12 15:31:17', NULL),
(885, 'Emvit-C Vitamin C 100mg 1000tabs Emzor (Counting)', NULL, '100mg', 'tablet', 'Emzor Pharma. Industries Ltd.', '6154000033330', 2, 12, 0, NULL, NULL, '2026-04-12 15:31:55', '2026-04-12 15:31:55', NULL),
(886, 'Nature\'s Field Vitamin D3 1000 IU 100 tabs Supplement Bottle', NULL, '1000 IU', 'tablet', NULL, '799872985903', 2, 12, 0, NULL, NULL, '2026-04-12 15:35:14', '2026-04-12 15:35:14', NULL),
(887, 'Cafergot 1mg Ergotamin x30Tabs(Asso Pharma Ltd', 'Ergotamin', '100mg', NULL, 'Asso Pharma Ltd', '2511029', 2, 38, 0, NULL, NULL, '2026-04-12 15:36:56', '2026-04-12 15:36:56', NULL),
(888, 'Nature\'s Field Vitamin D3 5000 IU 100 tabs Supplement Bottle', NULL, '5000 IU', 'tablet', NULL, '799872985910', 2, 12, 0, NULL, NULL, '2026-04-12 15:37:43', '2026-04-12 15:37:43', NULL),
(889, 'Nature\'s Field Vitamin E 1000 IU 100Softgels Supplement Bottle', NULL, '1000 IU', 'capsule', NULL, '799872985774', 2, 12, 0, NULL, NULL, '2026-04-12 15:40:34', '2026-04-12 15:40:34', NULL),
(890, 'Chapet Lip Balm x60 Stick', NULL, NULL, NULL, NULL, '856478581', 4, NULL, 0, NULL, NULL, '2026-04-12 15:43:13', '2026-04-12 15:43:13', NULL),
(891, 'Voltfast Diclofenac Potassium 50mg 30Sachets Novartis /Card', NULL, '50mg', NULL, 'Mipharm S.P.A.', 'VOLTFAST-50MG', 2, 10, 0, NULL, NULL, '2026-04-12 15:44:51', '2026-04-12 15:44:51', NULL),
(892, 'Nature\'s Field Chewable Vitamin C 500mg x60Tabs(Nature\'sField)', 'Vitamin', '500mg', NULL, 'Nature\'sField', '799872985620', 2, 12, 0, NULL, NULL, '2026-04-12 15:46:43', '2026-04-12 15:46:43', NULL),
(893, 'Co-codamol 30/500mg x100Tabs(Bristol Laborate. Ltd)', 'Codeine', '30/500mg', NULL, 'Bristol', '5060013943386', 2, 36, 0, NULL, NULL, '2026-04-12 15:50:26', '2026-04-12 15:50:26', NULL),
(894, 'USV Women\'s 14 Probiotic + Cranberry 50 Billion Org 90Caps', NULL, NULL, 'capsule', 'Intermex Atlantic Co. Ltd.', 'XOD3K5WLUF', 2, 34, 0, NULL, NULL, '2026-04-12 15:50:49', '2026-04-12 15:51:26', NULL),
(895, 'Co-codamol 8/500mg x100Tabs(Bristol Laborate. Ltd)', 'Codeine', '8/500mg', NULL, 'Bristol Laborate. Ltd', '5060013941627', 2, 36, 0, NULL, NULL, '2026-04-12 15:53:35', '2026-04-12 15:53:35', NULL),
(896, 'Angel Disposable Underpads X-Large 5pcs', NULL, NULL, NULL, NULL, '6958259358004', 2, 5, 0, NULL, NULL, '2026-04-12 15:57:04', '2026-04-12 15:57:04', NULL),
(897, 'Cognitol 5mg Vinpocetine 3x10Tabs(Tynoex Nig Ltd)', 'Vinpocetine', '5mg', NULL, 'Tynoex Nig Ltd', '705632601624', 2, 35, 0, NULL, NULL, '2026-04-12 15:57:24', '2026-04-12 15:57:24', NULL),
(898, 'USV CO Q10 100mg Boost Immune System 100Softgels', NULL, '100mg', 'capsule', 'Alfa Labs LLC', '659135716258', 2, 12, 0, NULL, NULL, '2026-04-12 16:02:10', '2026-04-12 16:02:10', NULL),
(899, 'Dapzin-10mg Dapagliflozine 3x10Tabs(MicroLabs)', 'Dapagliflozine', '10mg', NULL, 'MicroLabs', 'DZBHH0079', 2, 22, 0, NULL, NULL, '2026-04-12 16:03:36', '2026-04-12 16:03:36', NULL),
(900, 'Dapzin-5mg Dapagliflozin 3x10Tabs(MicroLab)', 'Dapagliflozin', '5mg', NULL, 'MicroLab', 'DZAHH0022', 2, 22, 0, NULL, NULL, '2026-04-12 16:06:48', '2026-04-12 16:06:48', NULL),
(901, 'Dettol Liquid 75ml', NULL, '75ml', NULL, NULL, '6151100281852', 4, NULL, 0, NULL, NULL, '2026-04-12 16:08:35', '2026-04-12 16:08:35', NULL),
(902, 'Unival 5mg Diazepam 10x10Tabs(Swipha)', 'Diazepam', '5mg', NULL, 'Swipha', 'L225041', 2, 36, 0, NULL, NULL, '2026-04-12 16:12:10', '2026-04-12 16:12:10', NULL),
(903, 'Drovid 200mg Ofloxacin(Tyonex Nig. Ltd)', 'Ofloxacin', NULL, NULL, 'Tyonex', '705632601648', 2, 8, 0, NULL, NULL, '2026-04-12 16:20:04', '2026-04-12 16:20:04', NULL),
(904, 'Codolin Expectorant Cough Syrup 100ml Tuyil Pharm.', NULL, NULL, 'syrup', 'Tuyil Pharm. Ind. Ltd.', 'CODOL100ML', 2, 11, 0, NULL, NULL, '2026-04-12 16:24:34', '2026-04-12 16:24:34', NULL),
(905, 'Angel Disposable Adult Diapers Medium x11Pcs(Fujian Sanitary Products Co. Ltd))', NULL, NULL, NULL, 'Fujian Sanitary Products Co. Ltd', '6958259390301', 2, 10, 0, NULL, NULL, '2026-04-12 16:30:02', '2026-04-12 16:30:02', NULL),
(906, 'Angel Disposable Adult Diapers X-Large x9Pcs(Fujian Sanitary Products Co. Ltd))', NULL, NULL, NULL, 'Fujian Sanitary Products Co. Ltd', '6958259390509', 2, 5, 0, NULL, NULL, '2026-04-12 16:34:28', '2026-04-12 16:34:28', NULL),
(907, 'Angel Disposable Adult Diapers XX-Large x8Pcs(Fujian Sanitary Products Co. Ltd))', NULL, NULL, NULL, '(Fujian Sanitary Products Co. Ltd', '6958259390578', 2, 5, 0, NULL, NULL, '2026-04-12 16:36:20', '2026-04-12 16:44:39', NULL),
(908, 'Angel Adult Pull Up Large x10Pcs(Fujian Sanitary Products Co. Ltd)', NULL, NULL, NULL, 'Fujian Sanitary Products Co. Ltd', '6958259395313', 2, 5, 0, NULL, NULL, '2026-04-12 16:39:31', '2026-04-12 16:39:31', NULL),
(909, 'Sensodyn Rapid Action 100g', NULL, NULL, NULL, NULL, '6161105662129', 2, 18, 0, NULL, NULL, '2026-04-13 10:33:02', '2026-04-13 10:33:02', NULL),
(910, 'Gillette blue shaving stick', NULL, NULL, NULL, NULL, '3014260283254', 4, NULL, 0, NULL, NULL, '2026-04-13 10:53:09', '2026-04-13 10:53:09', NULL),
(911, 'Fearless energy drink 500ml', NULL, NULL, NULL, NULL, '6156000153513', 4, NULL, 0, NULL, NULL, '2026-04-13 11:00:18', '2026-04-13 11:00:18', NULL),
(912, 'Bfresh classic toothbrush', NULL, NULL, NULL, NULL, '769503606606', 4, NULL, 0, NULL, NULL, '2026-04-13 11:05:04', '2026-04-13 11:05:04', NULL),
(913, 'Pro oral toothbrush medium', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-13 11:11:04', '2026-04-13 11:11:04', NULL),
(914, 'Pro oral soft children toohbrush', NULL, NULL, NULL, NULL, '6972595480113', 4, NULL, 0, NULL, NULL, '2026-04-13 11:14:41', '2026-04-13 11:14:41', NULL),
(915, 'Swiss Flower Air Freshner spring flower 500ml', NULL, NULL, NULL, NULL, '6154000107581', 4, NULL, 0, NULL, NULL, '2026-04-13 11:17:16', '2026-04-13 11:17:16', NULL),
(916, 'Swiss Flower Air Freshner tangerine 500ml', NULL, NULL, NULL, NULL, '6154000107000', 4, NULL, 0, NULL, NULL, '2026-04-13 11:20:49', '2026-04-13 11:20:49', NULL),
(917, 'Swiss Flower Air Freshner cool fresh 500ml', NULL, NULL, NULL, NULL, '6154000107024', 4, NULL, 0, NULL, NULL, '2026-04-13 11:25:45', '2026-04-13 11:25:45', NULL),
(918, 'Munch It crunchy snacks', NULL, NULL, NULL, NULL, '6154000101589', 4, NULL, 0, NULL, NULL, '2026-04-13 11:29:12', '2026-04-13 11:29:12', NULL),
(919, 'kissKid babay diaper midi 6-11kg', NULL, NULL, NULL, NULL, '608887092028', 4, NULL, 0, NULL, NULL, '2026-04-13 11:39:31', '2026-04-13 11:39:31', NULL),
(920, 'KissKids baby diaper maxi 9-16kg', NULL, NULL, NULL, NULL, '608887092035', 4, NULL, 0, NULL, NULL, '2026-04-13 11:44:32', '2026-04-13 11:44:32', NULL),
(921, 'KissKids baby diapers maxi 9-16kg 46pcs', NULL, NULL, NULL, NULL, '608887092066', 4, NULL, 0, NULL, NULL, '2026-04-13 11:48:03', '2026-04-13 11:48:03', NULL),
(922, 'KissKids baby diapers eco pack midi 5-11kg', NULL, NULL, NULL, NULL, '608887092059', 4, NULL, 0, NULL, NULL, '2026-04-13 11:52:11', '2026-04-13 11:52:11', NULL),
(923, 'KissKids baby diapers eco pack mini 3-8kg', NULL, NULL, NULL, NULL, '608887092042', 4, NULL, 0, NULL, NULL, '2026-04-13 11:55:39', '2026-04-13 11:55:39', NULL),
(924, 'Soft care baby diaper M 6-11kg', NULL, NULL, NULL, NULL, '6156000349282', 4, NULL, 0, NULL, NULL, '2026-04-13 12:06:09', '2026-04-13 12:06:09', NULL),
(925, 'Soft care baby diaper eco pack M  6-11KG', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-13 12:10:07', '2026-04-13 12:10:07', NULL),
(926, 'Soft care baby diapers eco pack 3-8 kg', NULL, NULL, NULL, NULL, '6156000349299', 4, NULL, 0, NULL, NULL, '2026-04-13 12:11:52', '2026-04-13 12:11:52', NULL),
(927, 'Soft care baby diapers eco pack 9-16kg', NULL, NULL, NULL, NULL, '6156000349275', 4, NULL, 0, NULL, NULL, '2026-04-13 12:16:58', '2026-04-13 12:16:58', NULL),
(928, 'Vixa Skineal Cream 15g (Vixa Biopharma Co Ltd)', 'Skineal', '15g', 'cream', 'Vixa', '15001671661688566779', 2, 4, 0, NULL, NULL, '2026-04-15 13:41:03', '2026-04-15 13:41:03', NULL),
(929, 'Cetilab 400 (Cimetidine) 400mg Tablets', 'Cimetidine', '400', 'tablet', 'Embassy', '08906045943703', 2, 7, 0, NULL, NULL, '2026-04-15 13:49:24', '2026-04-15 13:49:24', NULL),
(930, 'Tuxil N Cough, Cold & Allergy Syrup', 'Cough Syrup', '1.0', 'syrup', 'Fidson', '6154000373382', 2, 11, 0, NULL, NULL, '2026-04-15 14:07:07', '2026-04-15 14:07:07', NULL),
(931, 'Tuxil N Expectorant Children Cough, Cold & Allergy Syrup 2-12 yrs 100ml', 'Cough Syrup', '100ml', 'syrup', 'Fidson', NULL, 2, 11, 0, NULL, NULL, '2026-04-15 14:09:50', '2026-04-15 14:09:50', NULL),
(932, 'Arbitel-40 Telmisartan 40mg 3X10 Tablets  (Microlabs) *Per Card', 'Telmisartan', '40', 'tablet', 'Microlabs', '011890130217952610', 2, 23, 0, NULL, NULL, '2026-04-15 14:22:30', '2026-04-15 14:22:30', NULL),
(933, 'Daravit Omega Plus  3 X 10 Softgels (Elbe) *Per Card', 'Omega plus', '369', 'other', 'Elbe', '8906081544124', 2, 12, 0, NULL, NULL, '2026-04-15 14:27:28', '2026-04-15 14:27:28', NULL),
(934, 'Arbitel-80 Telmisartan 80mg 3 X10 Tablets (Microlabs) *Per Card', 'Telmisartan', '80', 'tablet', 'Microlabs', '011890130217953310', 2, 23, 0, NULL, NULL, '2026-04-15 14:31:52', '2026-04-15 14:31:52', NULL),
(935, 'Wellman Original tablets (Vitabiotics) *30 Capsules', 'Wellman', '2500', 'tablet', 'Vitabiotics', '5021265247684', 2, 12, 0, NULL, NULL, '2026-04-15 14:37:02', '2026-04-15 14:37:02', NULL),
(936, 'Flutex Fluoxetine Capsules 20mg 3 X 10mg (Fidson) *Per Card', 'Fluoxetine', '20', 'capsule', 'Fidson', '8906001820390', 2, NULL, 0, NULL, NULL, '2026-04-15 14:50:57', '2026-04-15 14:50:57', NULL),
(937, 'Tamsudart Dutasteride 0.5mg + Tamsulosin 0.4mg 3 X 10 Caps (Eldoxa LTD) * Per card', 'Dutasteride/Tamsulosin', '0.5/0.4', 'capsule', 'Eldoxa LTD', '8904177405588', 2, 30, 0, NULL, NULL, '2026-04-17 08:13:36', '2026-04-17 08:13:36', NULL),
(938, 'Scalp Vein 22G Needle *Each (UCH-MED)', 'Scalp Vein', NULL, 'injection', 'Crystal UCH', '240820', 2, 5, 0, NULL, NULL, '2026-04-17 08:28:02', '2026-04-18 16:22:33', NULL),
(939, 'Katartizo Raw Almond Nuts', 'Almond Nuts', NULL, 'other', 'Nesher Kanaph Ltd', NULL, 4, NULL, 0, NULL, NULL, '2026-04-17 08:34:08', '2026-04-17 08:34:08', NULL),
(940, 'Katartizo Raw Almond Nuts 125g', 'Almond Nuts', NULL, NULL, 'Nesher Kanaph Ltd', '0608887099744', 4, NULL, 0, NULL, NULL, '2026-04-17 08:35:26', '2026-04-17 08:35:26', NULL),
(941, 'Arthocare Glucosamine HCL and Chondroitin Sulphate *30 Caps (Fidson)', 'Glucosamine HCL and Chondroitin Sulphate', NULL, 'capsule', 'Fidson', '8908005958406', 2, 26, 0, NULL, NULL, '2026-04-17 08:40:15', '2026-04-17 08:40:15', NULL),
(942, 'Navidoxine Meclizine, B6 10 X 10 Tablets *Per Card (ZMC)', 'Meclizine, B6', NULL, 'tablet', 'ZMC', 'NAVIDOXINE(01)', 2, 34, 0, NULL, NULL, '2026-04-17 08:46:14', '2026-04-17 08:46:14', NULL),
(943, 'Collagen + Vitamin C and Biotin *90 Tablets (Basic Supplement)', 'Collagen', NULL, 'tablet', 'Basic Supplement', '783495589044', 2, NULL, 0, NULL, NULL, '2026-04-17 08:51:48', '2026-04-17 08:51:48', NULL),
(944, 'Lofnac-100 Diclofenac Sodium Suppository 100* Each', 'Diclofenac', '100', 'other', 'GVS Bliss', '8906009232263', 2, 10, 0, NULL, NULL, '2026-04-17 09:09:30', '2026-04-17 09:09:30', NULL),
(945, 'Lofnac-100 Diclofenac Sodium Suppositories 100mg (GVS Bliss) *Each', 'Diclofenac', '100', 'other', 'GVS Bliss', NULL, 2, 10, 0, NULL, NULL, '2026-04-17 09:13:01', '2026-04-17 09:13:01', NULL),
(946, 'Calgovit Calcium + Vitamin C + Vitamin D3 *Efferv. tabs X 20 tabs', 'Calcium Effer. Tabs', NULL, 'tablet', 'Oakleaf Pharmaceuticals', '3800048207471', 2, 12, 0, NULL, NULL, '2026-04-17 09:18:21', '2026-04-17 09:18:21', NULL),
(947, 'Cantab-V Clotrimazole Vaginal Tablets USP 100mg (Dupen)', 'Clotrimazole', '100', 'tablet', 'Dupen', '8906045302104', 2, 4, 0, NULL, NULL, '2026-04-17 09:28:17', '2026-04-17 09:28:17', NULL),
(948, 'La -Taste Aeroplane Basmati Rice 1kg', NULL, NULL, NULL, NULL, '8906004969539', 4, NULL, 0, NULL, NULL, '2026-04-17 09:34:45', '2026-04-17 09:34:45', NULL),
(949, 'Stilnox Zolpidem 10mg tablets *Per tablet', 'Zolpidem', '10', 'tablet', 'Sanofi', '3664798032826', 2, 25, 0, NULL, NULL, '2026-04-17 09:37:41', '2026-04-17 09:37:41', NULL),
(950, 'Royal Palace basmati Rice 1kg', NULL, NULL, NULL, NULL, '8901161106537', 4, NULL, 0, NULL, NULL, '2026-04-17 09:38:53', '2026-04-17 09:38:53', NULL),
(951, 'Asomex - 5 (Amlodipine Besilate) 5mg 3 X 10 Tablets *Per Card', 'Amlodipine Besilate', '5', 'tablet', 'Fidson', '8902319010607', 2, 23, 0, NULL, NULL, '2026-04-17 09:42:38', '2026-04-17 09:42:38', NULL),
(952, 'Golden Sella Pure Basmati Rice 1kg', NULL, NULL, NULL, NULL, '5061006190787', 4, NULL, 0, NULL, NULL, '2026-04-17 09:43:05', '2026-04-17 09:43:05', NULL),
(953, 'Golden Sella pure Basmati Rice 2kg', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-17 09:46:57', '2026-04-17 09:46:57', NULL),
(954, 'Easycare Blood Transfusion Set', 'Blood Transfusion Set', NULL, 'injection', 'Ishwari Healthcare', NULL, 2, 5, 0, NULL, NULL, '2026-04-17 09:48:43', '2026-04-17 09:48:43', NULL),
(955, 'Oluji Pure Cocoa Powder 250g', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-17 09:52:06', '2026-04-17 09:52:06', NULL),
(956, 'Astin-10 Atorvastatin 10mg 3 X 10 Tablets  *Per Card', 'Atorvastatin', '10', 'tablet', 'Micro labs', '011890130215870521', 2, 23, 0, NULL, NULL, '2026-04-17 09:55:29', '2026-04-17 09:55:29', NULL),
(957, 'Family Vegetable Crackers', NULL, NULL, NULL, NULL, '6955062600283', 4, NULL, 0, NULL, NULL, '2026-04-17 09:56:50', '2026-04-17 09:56:50', NULL),
(958, 'Ytacan Plus Cream 30g  (Sagar) *Triple Action', 'Clotrimazole', '30g', 'cream', 'Sagar', '6154000136109', 2, 4, 0, NULL, NULL, '2026-04-17 10:06:01', '2026-04-17 10:06:01', NULL),
(959, 'Hollandia Full Cream Evaporated 120g', NULL, NULL, NULL, NULL, '6151100054890', 4, NULL, 0, NULL, NULL, '2026-04-17 10:08:36', '2026-04-17 10:08:36', NULL),
(960, 'Asomex - 2.5mg Amlodipine Besilate 2.5mg Tablets 3 X 10 *Per Card', 'Amlodipine', '2.5', 'tablet', 'Fidson', '8902319010591', 2, 23, 0, NULL, NULL, '2026-04-17 10:10:21', '2026-04-17 10:10:21', NULL),
(961, 'CHI Barbeque Lighter', NULL, NULL, NULL, NULL, '6938564200014', 4, NULL, 0, NULL, NULL, '2026-04-17 10:13:49', '2026-04-17 10:13:49', NULL),
(962, 'Synriam', 'Arterolane Maleate and Piperaquine', '150 + 750', 'tablet', 'Sun Pharma', '8901296050545', 2, 20, 0, NULL, NULL, '2026-04-17 10:14:22', '2026-04-17 10:14:22', NULL),
(963, 'Synriam Arterolane Maleate and Piperaquine Tablets', 'Arterolane Maleate and Piperaquine Tablets', '150 + 750', 'tablet', 'Sun Pharma', NULL, 2, 20, 0, NULL, NULL, '2026-04-17 10:16:07', '2026-04-17 10:16:07', NULL),
(964, 'Cannula Yellow 24G', 'Cannula', NULL, 'injection', 'Santaz', '0108907520021138', 2, 5, 0, NULL, NULL, '2026-04-17 10:19:42', '2026-04-17 10:22:27', NULL),
(965, 'Clomid Clomiphene Citrate 50mg Tablets', 'Clomiphene Citrate', '50', 'tablet', 'Bruno', NULL, 2, 21, 0, NULL, NULL, '2026-04-17 10:37:25', '2026-04-17 10:37:25', NULL),
(966, 'ProNalix Indapamide Sustained release 1.5mg 3 X 10 Tablets (Provamati) *Per card', 'Indapamide', '1.5', 'tablet', 'ProvAmati', 'Pronalix', 2, 28, 0, NULL, NULL, '2026-04-17 10:45:17', '2026-04-17 10:45:17', NULL),
(967, 'Baby and Me multipurpose soap', NULL, NULL, NULL, NULL, '6156000108223', 4, NULL, 0, NULL, NULL, '2026-04-17 10:51:17', '2026-04-17 10:51:17', NULL),
(968, 'SUSTANON 250MG INJECTION', 'Testosteron', '250', 'injection', 'Aspen', '010869987408035910', 2, 21, 0, NULL, NULL, '2026-04-17 10:51:42', '2026-04-17 10:51:42', NULL),
(969, 'Hydrex Hydrochlorothiazide 25mg Tablets *Per tab', 'Hydrochlorothiazide', '25', 'tablet', 'Juhel', '6156000045634', 2, 28, 0, NULL, NULL, '2026-04-17 10:55:31', '2026-04-17 10:55:31', NULL),
(970, 'Vivi plus multipurpose soap 250g', NULL, NULL, NULL, NULL, '705632130162', 4, NULL, 0, NULL, NULL, '2026-04-17 10:56:06', '2026-04-17 10:56:06', NULL),
(971, 'Hydrex Hydrochlorothiazide 25mg Tablets *Per card', 'Hydrochlorothiazide', '25', 'tablet', 'Juhel', NULL, 2, 28, 0, NULL, NULL, '2026-04-17 10:56:50', '2026-04-17 10:56:50', NULL),
(972, 'Funbact-A Triple Action Cream 30gm', 'Clotrimazole', '30', 'cream', 'GVS Bliss', '8906009234083', 2, 4, 0, NULL, NULL, '2026-04-17 11:02:36', '2026-04-17 11:02:36', NULL),
(973, 'Golden Terra soy oil 700ml', NULL, NULL, NULL, NULL, '6152000505994', 4, NULL, 0, NULL, NULL, '2026-04-17 11:08:06', '2026-04-17 11:08:06', NULL),
(974, 'golden terra soya oil', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-17 12:58:08', '2026-04-17 12:58:08', NULL),
(975, 'Golden Terra soy oil 3l', NULL, NULL, NULL, NULL, '6152000507493', 4, NULL, 0, NULL, NULL, '2026-04-17 13:09:58', '2026-04-17 13:09:58', NULL),
(976, 'Rough Rider Studded Condom', 'Condom', NULL, 'other', 'Contempo', '5011831076862', 2, 17, 0, NULL, NULL, '2026-04-17 13:12:54', '2026-04-17 13:12:54', NULL),
(977, 'Sonia Tomatoe Mix 400g', NULL, NULL, NULL, NULL, '745114646224', 4, NULL, 0, NULL, NULL, '2026-04-17 13:18:24', '2026-04-17 13:18:24', NULL),
(978, 'Rekmal 60 Artesunate 60mg Injection (Zolon)', 'Artesunate', '60', 'injection', 'Zolon', '8905013008925', 2, 20, 0, NULL, NULL, '2026-04-17 13:36:34', '2026-04-17 13:36:34', NULL),
(979, 'Danacid Magnesium trisilicate tablets 12 X 8 *Per Card (Dana)', 'Magnesium trisilicate tablets', NULL, 'tablet', 'Dana', '6154000040239', 2, 7, 0, NULL, NULL, '2026-04-17 14:05:09', '2026-04-17 14:05:09', NULL),
(980, 'Amatem Softgel 20/120 Capsules X 24 Capsules (Elbe)', 'Arthemeter/Lumefantrine', '20/120', 'tablet', 'Elbe', 'AMATEM-24', 2, 20, 0, NULL, NULL, '2026-04-17 14:28:57', '2026-04-18 14:10:26', NULL),
(981, 'cway water 500ml', NULL, NULL, NULL, NULL, '6156000261201', 4, NULL, 0, NULL, NULL, '2026-04-18 09:47:45', '2026-04-18 11:19:22', '2026-04-18 11:19:22'),
(982, 'Cway drinkig water 750ml', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-18 09:49:52', '2026-04-18 09:49:52', NULL),
(987, 'Neofylin cough syrup ( mopson)', NULL, '100ml', 'syrup', 'mopson pharm', '6154000295004', 2, 11, 0, NULL, NULL, '2026-04-18 11:10:42', '2026-04-18 11:10:42', NULL),
(988, 'Cway drinkig water 750ml', NULL, NULL, NULL, NULL, '6156000261201', 4, NULL, 0, NULL, NULL, '2026-04-18 11:20:08', '2026-04-18 11:20:08', NULL),
(989, 'Postpil Levonorgestrel 1.5mg 1 tabs dkt', NULL, '1.5mg', 'tablet', 'DKT International', '8906088660186', 2, 39, 0, NULL, NULL, '2026-04-18 11:28:46', '2026-04-18 11:28:46', NULL),
(990, 'Alprazolam Zydus France 0.5mg 3x10 tabs /tabs', NULL, '0.5mg', 'tablet', NULL, 'ALPRAZOLAM0.5MG', 2, 25, 0, NULL, NULL, '2026-04-18 11:34:18', '2026-04-18 11:34:18', NULL),
(991, 'Gaviscon Liquid Peppermint 200ml', NULL, NULL, 'syrup', 'Rekitt Benckiser Healthcare UK', '5000158068766', 2, 7, 0, NULL, NULL, '2026-04-18 11:43:14', '2026-04-18 11:43:14', NULL),
(992, 'Golden penny semovita 1kg', NULL, NULL, NULL, NULL, '6156000051161', 4, NULL, 0, NULL, NULL, '2026-04-18 11:46:18', '2026-04-18 11:46:18', NULL),
(993, 'Crestor Rosuvastatin 10mg 2x14 tabs Registered /Card', NULL, '10mg', 'tablet', NULL, '5000456065047', 2, 23, 0, NULL, NULL, '2026-04-18 11:48:23', '2026-04-18 11:48:23', NULL),
(994, 'Pregnacare Original 30tabs Vitabiotics', NULL, NULL, 'tablet', 'Vitabiotics', '5021265245727', 2, 12, 0, NULL, NULL, '2026-04-18 11:52:25', '2026-04-18 11:52:25', NULL),
(995, 'Crown premium spaghetti 500g', NULL, NULL, NULL, NULL, '5296849400131', 4, NULL, 0, NULL, NULL, '2026-04-18 11:53:59', '2026-04-18 11:53:59', NULL),
(996, 'Seven Seas Omega 3 Fish Oil Cod Liver Oil High Strength x60caps', NULL, NULL, 'capsule', NULL, '5012335809208', 2, 12, 0, NULL, NULL, '2026-04-18 11:56:58', '2026-04-18 11:56:58', NULL),
(997, 'Golden penny spaghetti 500g', NULL, NULL, NULL, NULL, '6156000032207', 4, NULL, 0, NULL, NULL, '2026-04-18 11:58:22', '2026-04-18 11:58:22', NULL),
(998, 'Buttercup Original Cough Syrup 150ml', NULL, NULL, 'syrup', NULL, '5012616174803', 2, 12, 0, NULL, NULL, '2026-04-18 12:00:33', '2026-04-18 12:03:26', NULL),
(999, 'Gino tomatoe mix (satchet)', NULL, NULL, NULL, NULL, '8410300362708', 4, NULL, 0, NULL, NULL, '2026-04-18 12:01:49', '2026-04-18 12:01:49', NULL),
(1000, 'Pregnacare Plus Omega-3 Vitabiotics Dual Pack', NULL, NULL, NULL, 'Vitabiotics Ltd.', '5021265246434', 2, 12, 0, NULL, NULL, '2026-04-18 12:07:18', '2026-04-18 12:07:18', NULL),
(1001, 'Ayoola poundo yam flour .9kg', NULL, NULL, NULL, NULL, '6151100001023', 4, NULL, 0, NULL, NULL, '2026-04-18 12:07:41', '2026-04-18 12:07:41', NULL),
(1002, 'simply PENNE Pasta 500g', NULL, NULL, NULL, NULL, '4056489810360', 4, NULL, 0, NULL, NULL, '2026-04-18 12:12:16', '2026-04-18 12:12:16', NULL),
(1003, 'Osteocare Plus Glucosamine & Chondroitin Vitabiotics 60tabs', NULL, NULL, 'tablet', 'Vitabiotics Ltd.', '5021265254101', 2, 12, 0, NULL, NULL, '2026-04-18 12:22:43', '2026-04-18 12:22:43', NULL),
(1004, 'Feroglobin B12 Liquid Iron Zinc, B Complex Vitabiotics', NULL, NULL, 'syrup', 'Vitabiotics Ltd', '5021265247783', 2, 9, 0, NULL, NULL, '2026-04-18 12:25:40', '2026-04-18 12:25:40', NULL),
(1005, 'Honey (Waye\'s bee co)', NULL, NULL, NULL, NULL, '6156000301433', 4, NULL, 0, NULL, NULL, '2026-04-18 12:28:15', '2026-04-18 12:28:15', NULL),
(1006, 'WellKid Multi-Vitamin Smart 30 Chewable tabs 4-12yrs Vitabiotics', NULL, NULL, 'tablet', 'Vitabiotics', '5021265247745', 2, 12, 0, NULL, NULL, '2026-04-18 12:30:27', '2026-04-18 12:30:27', NULL),
(1007, 'Haliborange Omega-3 DHA 3-12 Years 300ml', NULL, NULL, 'syrup', NULL, '5060216565002', 2, 12, 0, NULL, NULL, '2026-04-18 12:33:08', '2026-04-18 12:33:08', NULL),
(1008, 'Vaseline  lotion 400ml', NULL, NULL, NULL, NULL, '6001087011143', 4, NULL, 0, NULL, NULL, '2026-04-18 12:34:29', '2026-04-18 13:06:21', NULL),
(1009, 'Postinor 2 Levonorgestrel 0.75mg 2tabs', NULL, '0.75mg', 'tablet', NULL, '5997001359235', 2, 39, 0, NULL, NULL, '2026-04-18 12:36:26', '2026-04-18 12:36:26', NULL),
(1010, 'Norite Natural Omega-3 1000mg x100 Softgels', NULL, '1000mg', 'capsule', 'Earth\'s Creation USA', '608786722156', 2, 12, 0, NULL, NULL, '2026-04-18 12:41:19', '2026-04-18 12:41:19', NULL),
(1011, 'Norite Natural Triple Omega 3,6,9 1000mg x120 Softgels', NULL, '1000mg', 'capsule', 'Earth\'s Creation USA', '608786722170', 2, 12, 0, NULL, NULL, '2026-04-18 12:46:00', '2026-04-18 12:46:00', NULL),
(1012, 'Norite Timed Release Vitamin C 1000mg x100 tabs', NULL, '1000mg', 'tablet', 'Earth\'s Creation USA', '608786723658', 2, 12, 0, NULL, NULL, '2026-04-18 12:49:26', '2026-04-18 12:49:26', NULL),
(1013, 'Norite Cranberry Fruit Concentrate 8,400mg 60 Softgels', NULL, '8400mg', 'capsule', 'Earth\'s Creation USA', '608786723757', 2, 12, 0, NULL, NULL, '2026-04-18 12:52:39', '2026-04-18 12:52:39', NULL),
(1014, 'Norite Evening Primerose Oil 1000mg x60 Softgels', NULL, '1000mg', 'capsule', 'Earth\'s Creation USA', '608786726475', 2, 12, 0, NULL, NULL, '2026-04-18 12:55:25', '2026-04-18 12:55:25', NULL),
(1015, 'Norite Chelated Calcium Mag Zinc + Vitamin D3 x100 Softgels', NULL, NULL, 'capsule', 'Earth\'s Creation USA', '608786726703', 2, 12, 0, NULL, NULL, '2026-04-18 12:57:57', '2026-04-18 12:57:57', NULL),
(1016, 'Norite High Abs Magnesium Glycinate 360mg x90Caps', NULL, '360mg', 'capsule', 'Earth\'s Creation USA', '608786727069', 2, 12, 0, NULL, NULL, '2026-04-18 13:00:37', '2026-04-18 13:00:37', NULL),
(1017, 'Norite Natural Probiotics Acidophilus 100 Million x100 Softgels', NULL, NULL, 'capsule', 'Earth\'s Creation USA', '608786729780', 2, 12, 0, NULL, NULL, '2026-04-18 13:06:23', '2026-04-18 13:06:23', NULL),
(1018, 'Dr. Nwakor\'s Herbal Mixture 7 Keys  200ml', NULL, NULL, 'syrup', NULL, '6156000390505', 2, 12, 0, NULL, NULL, '2026-04-18 13:08:34', '2026-04-18 13:08:34', NULL),
(1019, 'Palmer\'s Skin success soap', NULL, NULL, NULL, NULL, '010181173806', 4, NULL, 0, NULL, NULL, '2026-04-18 13:08:59', '2026-04-18 13:08:59', NULL),
(1020, 'Reload Immunity Formula 120 Count Dietary Supplement', NULL, NULL, 'tablet', NULL, '615225000287', 2, 12, 0, NULL, NULL, '2026-04-18 13:10:56', '2026-04-18 13:10:56', NULL),
(1021, 'Emzor Paracetamol Syrup 125mg/5ml 60ml', NULL, '125mg', 'syrup', 'Emzor Pharma Industries Ltd.', '6154000033026', 2, 10, 0, NULL, NULL, '2026-04-18 13:13:36', '2026-04-18 13:13:36', NULL),
(1022, 'Immunboost 1-A-Day Multi Vitamin & Mineral  90tabs', NULL, NULL, 'tablet', NULL, '781360814932', 2, 12, 0, NULL, NULL, '2026-04-18 13:20:25', '2026-04-18 13:20:25', NULL),
(1023, 'Nature\'s Filed B-12 50mcg 100 tabs Dietary Supplement', NULL, '50mcg', 'tablet', NULL, '799872985798', 2, 12, 0, NULL, NULL, '2026-04-18 13:24:47', '2026-04-18 13:24:47', NULL),
(1024, 'Dr Teal\'s Bathing Soap', NULL, NULL, NULL, NULL, '8110680122311', 4, NULL, 0, NULL, NULL, '2026-04-18 13:25:59', '2026-04-18 13:25:59', NULL),
(1025, 'Goeth Extra Virgin Olive Oil No-Cholesterol 250ml', NULL, NULL, NULL, NULL, '8410269122009', 2, NULL, 0, NULL, NULL, '2026-04-18 13:28:25', '2026-04-18 13:28:25', NULL),
(1026, 'Amlodipine Besylate 5mg 2x14 tabs Pocco /Card', NULL, '5mg', 'tablet', 'Scott-Edil Pharmacia Ltd.', '8904159402383', 2, 23, 0, NULL, NULL, '2026-04-18 13:35:06', '2026-04-18 13:35:06', NULL),
(1027, 'Dove Advanced Care', NULL, NULL, NULL, NULL, '8717163997345', 4, NULL, 0, NULL, NULL, '2026-04-18 13:36:24', '2026-04-18 13:36:24', NULL),
(1028, 'Abeeta Arteether 150mg/2ml Injection x3 Ampoules', NULL, '150mg', 'injection', 'Afrigenerics Ltd.', '8901108807978', 2, 20, 0, NULL, NULL, '2026-04-18 13:39:09', '2026-04-18 13:39:09', NULL),
(1029, 'Dove Advance care go fresh body spray', NULL, NULL, NULL, NULL, '8711600786257', 4, NULL, 0, NULL, NULL, '2026-04-18 13:41:34', '2026-04-18 13:41:34', NULL),
(1030, 'Fexomal Arteether 225mg/3ml x3Ampoules  Injection', NULL, '225mg', 'injection', 'Zee Laboratories Ltd.', '8904334126738', 2, 20, 0, NULL, NULL, '2026-04-18 13:43:08', '2026-04-18 13:43:08', NULL),
(1031, 'Daravit Regular Multi. & Mineral 3x10 Softgels  /Card', NULL, NULL, 'capsule', NULL, '714084877556', 2, 12, 0, NULL, NULL, '2026-04-18 13:47:09', '2026-04-18 13:47:09', NULL),
(1032, 'Dove Men Care bodyspray', NULL, NULL, NULL, NULL, '8710908325823', 4, NULL, 0, NULL, NULL, '2026-04-18 13:47:22', '2026-04-18 13:47:22', NULL),
(1033, 'Clarion Vitamin A 200,000 IU 3x10Caps /Card', NULL, '200,000 IU', 'capsule', 'Clarion Medicals Limited', '8904324900386', 2, 12, 0, NULL, NULL, '2026-04-18 13:53:06', '2026-04-18 13:53:06', NULL),
(1034, 'Biofem Alcohol 100 Prep Pad Isopropyl 70%', NULL, NULL, NULL, 'Biofem', '6950423262117', 2, 5, 0, NULL, NULL, '2026-04-18 13:56:59', '2026-04-18 13:56:59', NULL),
(1035, 'ACCU-CHEK 200 Lancets /1 bag of 100', NULL, NULL, NULL, NULL, 'ACCU-200LANCETS', 2, 5, 0, NULL, NULL, '2026-04-18 14:00:43', '2026-04-18 14:00:43', NULL),
(1036, 'Afrab Vite Multivitamin Drops 15ml', NULL, NULL, 'drops', 'Afrab- Chem Ltd.', '6154000240493', 2, 12, 0, NULL, NULL, '2026-04-18 14:03:46', '2026-04-18 14:03:46', NULL),
(1037, 'VO5 Promegranate bliss conditioner', NULL, NULL, NULL, NULL, '816559019857', 4, NULL, 0, NULL, NULL, '2026-04-18 14:09:31', '2026-04-18 14:09:31', NULL),
(1038, 'Amatem Softgel 20/120 Capsules X 12 Capsules (Elbe)', NULL, '20/120MG', 'capsule', 'Elbe', NULL, 2, 20, 0, NULL, NULL, '2026-04-18 14:11:58', '2026-04-18 14:11:58', NULL),
(1039, 'Arthocare Forte Supplement 30 Caplets Fidson', NULL, NULL, 'tablet', 'Fidson Healthcare Plc', '8908005958413', 2, 12, 0, NULL, NULL, '2026-04-18 14:15:54', '2026-04-18 14:15:54', NULL),
(1040, 'VO5 Kiwi lime  shampoo', NULL, NULL, NULL, NULL, '816559011066', 4, NULL, 0, NULL, NULL, '2026-04-18 14:17:39', '2026-04-18 14:17:39', NULL),
(1041, 'V05 Strawberries and cream conditioner', NULL, NULL, NULL, NULL, '816559011189', 4, NULL, 0, NULL, NULL, '2026-04-18 14:21:09', '2026-04-18 14:21:09', NULL),
(1042, 'Vaseline bluesael cocoa butter 100ml', NULL, NULL, NULL, NULL, '60018960', 4, NULL, 0, NULL, NULL, '2026-04-18 14:23:41', '2026-04-18 14:23:41', NULL),
(1043, 'Brustan-N Ibuprofen Suspension 100mg/5ml 100ml', NULL, '100mg', 'syrup', 'Sun Pharma. Ind. Ltd.', 'BRUSTAN-100ML', 2, 10, 0, NULL, NULL, '2026-04-18 14:25:39', '2026-04-18 14:25:39', NULL),
(1044, 'Brustan-N Ibuprofen Suspension 100mg/5ml 60ml', NULL, '100mg', 'syrup', 'Sun Pharma. Ind. Ltd.', 'BRUSTAN-60ML', 2, 10, 0, NULL, NULL, '2026-04-18 14:29:09', '2026-04-18 14:29:09', NULL),
(1045, 'E45 Skin nourishing soap 250g', NULL, NULL, NULL, NULL, NULL, 4, NULL, 0, NULL, NULL, '2026-04-18 14:31:26', '2026-04-18 14:31:26', NULL),
(1046, 'Retin -A soap  100g', NULL, NULL, NULL, NULL, '6971393292829', 4, NULL, 0, NULL, NULL, '2026-04-18 14:34:42', '2026-04-18 14:34:42', NULL),
(1047, 'Cannula Pink I.V. 20G', NULL, NULL, 'injection', NULL, 'CANNULA-PINK', 2, 5, 0, NULL, NULL, '2026-04-18 14:35:19', '2026-04-18 14:35:19', NULL),
(1048, 'Cannula Green 18G', NULL, NULL, 'injection', NULL, 'CANNULA-GREEN', 2, 5, 0, NULL, NULL, '2026-04-18 14:40:41', '2026-04-18 14:40:41', NULL),
(1049, 'dove men care soap', NULL, NULL, NULL, NULL, '4800888157492', 4, NULL, 0, NULL, NULL, '2026-04-18 14:41:45', '2026-04-18 14:41:45', NULL),
(1050, 'Citramin 100mg/ml Vitamin C drops Afrab', NULL, '100mg', 'syrup', 'Afrab-Chem Ltd.', '6154000240066', 2, 12, 0, NULL, NULL, '2026-04-18 14:43:16', '2026-04-18 14:43:16', NULL),
(1051, 'Clara Herbal Mixture 100ml', NULL, NULL, 'syrup', 'Dr. F. C. Eze African', 'CLARA-100ML', 2, 12, 0, NULL, NULL, '2026-04-18 14:46:08', '2026-04-18 14:46:08', NULL),
(1052, 'D-Koff Cough Expectorant Cough Cold Catarrh 100ml', NULL, NULL, 'syrup', 'Jawa International Ltd.', '6154000056001', 2, 11, 0, NULL, NULL, '2026-04-18 14:52:19', '2026-04-18 14:52:19', NULL),
(1053, 'Dettol Original 150g', NULL, NULL, NULL, NULL, '6151100283719', 4, NULL, 0, NULL, NULL, '2026-04-18 14:53:25', '2026-04-18 14:53:25', NULL),
(1054, 'Dettol Original 70g', NULL, NULL, NULL, NULL, '6151100282828', 4, NULL, 0, NULL, NULL, '2026-04-18 14:58:19', '2026-04-18 14:58:19', NULL),
(1055, 'EMAL Arteether Injection 75ml/2ml 3x2ml (Fidson)', NULL, '75mg', 'injection', 'Fidson Healthcare Plc', 'E-MAL-75MG', 2, 20, 0, NULL, NULL, '2026-04-18 14:58:41', '2026-04-18 14:58:41', NULL),
(1056, 'Eden Lisinopril 5mg 2x14tabs Medico Remedies /Card', NULL, '5mg', 'tablet', 'Medico Remedies Ltd.', '8904181402115', 2, 23, 0, NULL, NULL, '2026-04-18 15:01:26', '2026-04-18 15:47:07', NULL),
(1057, 'My Love Natural Spray 30ml', NULL, NULL, NULL, NULL, '6291106642513', 4, NULL, 0, NULL, NULL, '2026-04-18 15:03:05', '2026-04-18 15:03:05', NULL),
(1058, 'Em-Vit-C Drops 15ml Emzor', NULL, NULL, 'drops', 'Emzor Pharma Industries Ltd.', '6154000033446', 2, 12, 0, NULL, NULL, '2026-04-18 15:04:31', '2026-04-18 15:04:31', NULL),
(1059, 'Exforge Amlodipine/Valsartan 10/160mg 2x14tabs /Card', NULL, '10/160mg', 'tablet', 'Novartis', 'EXFORGE10/160MG', 2, 23, 0, NULL, NULL, '2026-04-18 15:08:08', '2026-04-18 15:08:08', NULL),
(1060, 'Dove Beauty Bar soap 90g', NULL, NULL, NULL, NULL, '8000700000005', 4, NULL, 0, NULL, NULL, '2026-04-18 15:13:36', '2026-04-18 15:13:36', NULL),
(1061, 'Gestid Plus 100ml With Ginger Aniseed Mint', NULL, NULL, 'syrup', 'Sun Pharmaceutical', 'GESTIDPLUS-100ML', 2, 7, 0, NULL, NULL, '2026-04-18 15:13:41', '2026-04-18 15:13:41', NULL),
(1062, 'Ginsomin Eve Plus Ginseng Extract 3x10Caps /Card', NULL, NULL, 'capsule', 'Mega Lifescineces (Australia) PTY. Ltd.', '8850769015003', 2, 12, 0, NULL, NULL, '2026-04-18 15:17:39', '2026-04-18 15:17:39', NULL),
(1063, 'Gestid Suspension 100ml', NULL, NULL, 'syrup', 'Sun Pharmaceutical', 'GESTID-100ML', 2, 7, 0, NULL, NULL, '2026-04-18 15:21:08', '2026-04-18 15:21:08', NULL),
(1064, 'Gyno-Tiocosid Tioconazole 100mg 3 V. tabs Neimeth', NULL, '100mg', NULL, 'Neimeth International Pharma Plc.', 'GYNO-100MG', 2, 4, 0, NULL, NULL, '2026-04-18 15:23:52', '2026-04-18 15:23:52', NULL),
(1065, 'Rice Milk Soap Gluta + Collagen 12g', NULL, NULL, NULL, NULL, 'https://www.facebook.com/qr/110955895152275', 4, NULL, 0, NULL, NULL, '2026-04-18 15:29:02', '2026-04-18 15:29:02', NULL),
(1066, 'Face Facts. Blemish Gel Moisturiser 50ml', NULL, NULL, NULL, NULL, '5031413935691', 4, NULL, 0, NULL, NULL, '2026-04-18 15:36:36', '2026-04-18 15:36:36', NULL),
(1067, 'Ketofung Ketoconazole 2% Shampoo 100ml DGF', NULL, NULL, NULL, 'DrugField Pharma. Ltd.', '6156000318318', 2, 4, 0, NULL, NULL, '2026-04-18 15:37:18', '2026-04-18 15:37:18', NULL),
(1068, 'Eden Lisinopril 10mg 2x14tabs Medico Remedies /Card', NULL, '10mg', 'tablet', 'Medico Remedies Ltd.', '8904181402122', 2, 23, 0, NULL, NULL, '2026-04-18 15:49:21', '2026-04-18 15:49:21', NULL),
(1069, 'Lynsunate Artemether Inj 80mg/ml x6 Ampoules', NULL, '80mg', 'injection', 'Lyn-Edge Pharma. Ltd.', '011890606', 2, 20, 0, NULL, NULL, '2026-04-18 15:53:46', '2026-04-18 15:53:46', NULL),
(1070, 'Mycoten Baby Care Cream 20g DGF', NULL, NULL, 'cream', 'DrugField Pharma. Ltd.', '6156000158235', 2, 4, 0, NULL, NULL, '2026-04-18 16:01:37', '2026-04-18 16:01:37', NULL),
(1071, 'Oxyurea Hydroxyurea 250mg 3x10 Caps (Bond Chenical) /Card', NULL, '250mg', 'capsule', 'Bond Chemical Ind. Ltd.', 'OXYUREA-250MG', 2, NULL, 0, NULL, NULL, '2026-04-18 16:07:58', '2026-04-18 16:07:58', NULL),
(1072, 'Face Facts. Moisturising Gel Cream 50ml', NULL, NULL, NULL, NULL, '5031413928570', 4, NULL, 0, NULL, NULL, '2026-04-18 16:11:03', '2026-04-18 16:11:03', NULL),
(1073, 'Panda Paracetamol Syrup 125mg/5ml 60ml (Afrab)', NULL, '125mg', 'syrup', 'Afrab-Chem Ltd.', '6154000240226', 2, 10, 0, NULL, NULL, '2026-04-18 16:12:08', '2026-04-18 16:12:08', NULL),
(1074, 'Promethazine Syrup 5mg/5ml 60ml Mopson', NULL, '5mg', 'syrup', 'Mopson Pharma. Ltd.', '6154000295073', 2, 6, 0, NULL, NULL, '2026-04-18 16:15:04', '2026-04-18 16:15:04', NULL),
(1075, 'R-Retard Slow-K-600MG Potassium Chloride 10tabs', NULL, '600mg', 'tablet', 'Kaler Biopharmachem. Ltd.', 'R-RETARD600MG', 2, NULL, 0, NULL, NULL, '2026-04-18 16:18:26', '2026-04-18 16:18:26', NULL),
(1076, 'Scalp Vein 23G Needle *Each (MEDIFIT)', NULL, NULL, 'injection', NULL, '20241230', 2, 5, 0, NULL, NULL, '2026-04-18 16:23:55', '2026-04-18 16:23:55', NULL),
(1077, 'Scalp Vein 21G Needle *Each (APEX)', NULL, NULL, 'injection', NULL, '250310', 2, 5, 0, NULL, NULL, '2026-04-18 16:27:36', '2026-04-18 16:27:36', NULL),
(1078, 'Spirocard Spironolactone 25mg 10x10tabs Popular /Card', NULL, '25mg', 'tablet', 'Popular Pharma. Ltd.', 'SPIROCARD25MG', 2, 23, 0, NULL, NULL, '2026-04-18 16:32:41', '2026-04-18 16:32:41', NULL),
(1079, 'Galways Tacorange Vitamin C Syrup 100mg/5ml SKG', NULL, '100mg', 'syrup', 'SKG-Pharma Ltd.', '608887011715', 2, 12, 0, NULL, NULL, '2026-04-18 16:36:22', '2026-04-18 16:36:22', NULL),
(1080, 'Tamether Fort - 80/480 Adult 6tabs', NULL, '80/480', 'tablet', 'Vixa Pharma. Co. Ltd.', '6971161600238', 2, 20, 0, NULL, NULL, '2026-04-18 16:39:39', '2026-04-18 16:39:39', NULL),
(1081, 'Traxin Ceftriaxone 1g Clarion Medicals Ltd.', NULL, '1g', 'injection', 'Clarion Medicals Ltd.', 'TRIAXIN-1G', 2, 8, 0, NULL, NULL, '2026-04-18 16:43:55', '2026-04-18 16:43:55', NULL),
(1082, 'Traxin-S Ceftriaxone + Sulbactam 1g Clarion Medicals Ltd.', NULL, '1.5g', 'injection', 'Clarion Medicals Ltd.', 'TRIAXIN-S-1G', 2, 8, 0, NULL, NULL, '2026-04-18 16:47:25', '2026-04-18 16:47:25', NULL),
(1083, 'ViBOOST Vitamin E 1000 IU 3x10Caps Clarion', NULL, '1000 IU', 'capsule', 'Clarion Medicals Ltd.', 'VIBOOST-1000', 2, 12, 0, NULL, NULL, '2026-04-18 16:50:52', '2026-04-18 16:50:52', NULL),
(1084, 'Zolat Albendazole 200mg 2 tabs Emzor', NULL, '200mg', 'tablet', 'Emzor Pharma. Indurstries Ltd.', '6154000034016', 2, 34, 0, NULL, NULL, '2026-04-18 16:59:10', '2026-04-18 16:59:10', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `goods_received_items`
--

CREATE TABLE `goods_received_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `grn_id` bigint(20) UNSIGNED NOT NULL,
  `drug_id` bigint(20) UNSIGNED NOT NULL,
  `batch_number` varchar(100) NOT NULL COMMENT 'Batch/lot number from supplier',
  `manufacturing_date` date DEFAULT NULL COMMENT 'Manufacturing date',
  `expiry_date` date NOT NULL COMMENT 'Expiry date',
  `quantity_received` int(11) NOT NULL COMMENT 'Quantity received',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Unit price',
  `quality_check_passed` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Quality check status',
  `quality_notes` text DEFAULT NULL COMMENT 'Quality check notes',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `goods_received_notes`
--

CREATE TABLE `goods_received_notes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `grn_number` varchar(50) NOT NULL COMMENT 'Auto-generated GRN number (GRN-YYYY-MM-NNNN)',
  `purchase_order_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `received_by` bigint(20) UNSIGNED NOT NULL,
  `received_date` date NOT NULL COMMENT 'Date goods were received',
  `status` enum('pending_quality_check','approved','rejected') NOT NULL DEFAULT 'pending_quality_check' COMMENT 'GRN status',
  `notes` text DEFAULT NULL COMMENT 'Receiving notes',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(2, '2024_01_01_000001_create_roles_table', 1),
(3, '2024_01_01_000002_create_permissions_table', 1),
(4, '2024_01_01_000003_create_role_permissions_table', 1),
(5, '2024_01_01_000004_create_branches_table', 1),
(6, '2024_01_01_000005_create_users_table', 1),
(7, '2024_01_01_000006_create_drugs_table', 1),
(8, '2024_01_01_000007_create_stock_items_table', 1),
(9, '2024_01_01_000008_create_stock_movements_table', 1),
(10, '2024_01_01_000009_create_suppliers_table', 1),
(11, '2024_01_01_000010_create_purchase_orders_table', 1),
(12, '2024_01_01_000011_create_purchase_order_items_table', 1),
(13, '2024_01_01_000012_create_goods_received_notes_table', 1),
(14, '2024_01_01_000013_create_goods_received_items_table', 1),
(15, '2024_01_01_000014_create_sales_table', 1),
(16, '2024_01_01_000015_create_sale_items_table', 1),
(17, '2024_01_01_000016_create_payments_table', 1),
(18, '2024_01_01_000017_create_stock_transfers_table', 1),
(19, '2024_01_01_000018_create_stock_transfer_items_table', 1),
(20, '2024_01_01_000019_create_notifications_table', 1),
(21, '2024_01_01_000020_create_password_reset_tokens_table', 1),
(22, '2024_01_01_000021_create_sessions_table', 1),
(23, '2024_01_15_000001_add_authorization_code_to_users_table', 1),
(24, '2026_01_06_223118_add_barcode_to_drugs_table', 1),
(25, '2026_01_07_232126_create_categories_table', 1),
(26, '2026_01_07_232136_create_subcategories_table', 1),
(27, '2026_01_07_232146_add_category_fields_to_drugs_table', 1),
(28, '2026_01_08_000001_add_return_fields_to_sales', 1),
(29, '2026_01_08_100001_create_system_configs_table', 1),
(30, '2026_01_10_201800_remove_nafdac_number_from_drugs_table', 2),
(31, '2026_01_10_202900_make_drug_fields_nullable', 3),
(32, '2026_01_13_000001_add_discount_authorized_by_to_sales_table', 4),
(33, '2026_04_18_104907_allow_barcode_reuse_for_soft_deleted_drugs', 5),
(34, '2026_04_18_121000_create_barcode_unique_active_index', 5);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('expiry_alert','low_stock','reorder_point','approval_required','system') NOT NULL COMMENT 'Notification type',
  `title` varchar(255) NOT NULL COMMENT 'Notification title',
  `message` text NOT NULL COMMENT 'Notification message',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Additional notification data (JSON)' CHECK (json_valid(`data`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Read status',
  `read_at` timestamp NULL DEFAULT NULL COMMENT 'Read timestamp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `payment_method` enum('cash','card','transfer','mobile_money') NOT NULL COMMENT 'Payment method',
  `amount` decimal(12,2) NOT NULL COMMENT 'Payment amount',
  `reference_number` varchar(100) DEFAULT NULL COMMENT 'Transaction reference (for card/transfer)',
  `payment_date` datetime NOT NULL COMMENT 'Payment date and time',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `sale_id`, `payment_method`, `amount`, `reference_number`, `payment_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'cash', 1000.00, NULL, '2026-01-10 21:56:00', '2026-01-10 20:57:07', '2026-01-10 20:57:07'),
(2, 1, 'card', 1400.00, NULL, '2026-01-10 21:56:00', '2026-01-10 20:57:07', '2026-01-10 20:57:07'),
(3, 2, 'cash', 2400.00, NULL, '2026-01-10 22:13:00', '2026-01-10 21:13:27', '2026-01-10 21:13:27'),
(4, 3, 'cash', 2400.00, NULL, '2026-01-10 22:31:00', '2026-01-10 21:31:41', '2026-01-10 21:31:41'),
(5, 4, 'cash', 2400.00, NULL, '2026-01-13 19:54:00', '2026-01-13 18:55:16', '2026-01-13 18:55:16'),
(6, 5, 'cash', 9600.00, NULL, '2026-01-13 19:55:00', '2026-01-13 19:01:33', '2026-01-13 19:01:33'),
(7, 6, 'cash', 4790.00, NULL, '2026-01-13 20:13:00', '2026-01-13 19:14:22', '2026-01-13 19:14:22'),
(8, 7, 'cash', 2390.00, NULL, '2026-01-13 20:25:00', '2026-01-13 19:25:32', '2026-01-13 19:25:32'),
(9, 8, 'cash', 2390.00, NULL, '2026-01-13 21:09:00', '2026-01-13 20:10:14', '2026-01-13 20:10:14'),
(10, 9, 'cash', 1400.00, NULL, '2026-01-13 21:35:00', '2026-01-13 20:49:51', '2026-01-13 20:49:51'),
(11, 9, 'card', 1000.00, NULL, '2026-01-13 21:35:00', '2026-01-13 20:49:51', '2026-01-13 20:49:51'),
(12, 10, 'cash', 1000.00, NULL, '2026-01-13 21:50:00', '2026-01-13 20:51:06', '2026-01-13 20:51:06'),
(13, 10, 'card', 1400.00, NULL, '2026-01-13 21:50:00', '2026-01-13 20:51:06', '2026-01-13 20:51:06'),
(14, 11, 'cash', 2400.00, NULL, '2026-01-13 22:12:00', '2026-01-13 21:13:10', '2026-01-13 21:13:10'),
(15, 12, 'cash', 20000.00, NULL, '2026-01-23 10:30:00', '2026-01-23 09:32:18', '2026-01-23 09:32:18'),
(16, 12, 'card', 3650.00, NULL, '2026-01-23 10:30:00', '2026-01-23 09:32:18', '2026-01-23 09:32:18'),
(17, 13, 'cash', 12900.00, NULL, '2026-01-23 11:02:00', '2026-01-23 10:02:28', '2026-01-23 10:02:28'),
(18, 14, 'cash', 12900.00, NULL, '2026-01-24 00:39:00', '2026-01-23 23:39:49', '2026-01-23 23:39:49'),
(19, 15, 'cash', 12900.00, NULL, '2026-01-24 00:56:00', '2026-01-23 23:56:44', '2026-01-23 23:56:44'),
(20, 16, 'cash', 12900.00, NULL, '2026-01-24 01:02:00', '2026-01-24 00:02:55', '2026-01-24 00:02:55'),
(21, 17, 'cash', 12900.00, NULL, '2026-01-24 01:03:00', '2026-01-24 00:03:16', '2026-01-24 00:03:16'),
(22, 18, 'cash', 12000.00, NULL, '2026-01-24 01:03:00', '2026-01-24 00:04:09', '2026-01-24 00:04:09'),
(23, 18, 'card', 900.00, NULL, '2026-01-24 01:03:00', '2026-01-24 00:04:09', '2026-01-24 00:04:09'),
(24, 19, 'cash', 12900.00, NULL, '2026-01-24 01:19:00', '2026-01-24 00:19:28', '2026-01-24 00:19:28'),
(25, 20, 'cash', 12900.00, NULL, '2026-01-24 01:58:00', '2026-01-24 00:59:01', '2026-01-24 00:59:01'),
(26, 21, 'cash', 12900.00, NULL, '2026-01-24 02:00:00', '2026-01-24 01:00:18', '2026-01-24 01:00:18'),
(27, 22, 'cash', 85000.00, NULL, '2026-01-24 21:08:00', '2026-01-24 20:12:27', '2026-01-24 20:12:27'),
(28, 23, 'cash', 850.00, NULL, '2026-01-24 22:11:00', '2026-01-24 21:12:22', '2026-01-24 21:12:22'),
(29, 24, 'cash', 11700.00, NULL, '2026-01-25 00:28:00', '2026-01-24 23:30:07', '2026-01-24 23:30:07'),
(30, 25, 'cash', 41650.00, NULL, '2026-01-25 13:18:00', '2026-01-25 12:23:07', '2026-01-25 12:23:07'),
(31, 26, 'cash', 29562.50, NULL, '2026-01-25 13:24:00', '2026-01-25 12:27:59', '2026-01-25 12:27:59'),
(32, 27, 'cash', 1204.00, NULL, '2026-04-14 13:22:00', '2026-04-14 12:25:23', '2026-04-14 12:25:23'),
(33, 28, 'card', 1050.00, '177617381683', '2026-04-14 13:40:00', '2026-04-14 12:42:22', '2026-04-14 12:42:22'),
(34, 29, 'card', 1700.00, NULL, '2026-04-14 15:48:00', '2026-04-14 14:57:32', '2026-04-14 14:57:32'),
(35, 30, 'card', 3238.44, NULL, '2026-04-15 15:53:00', '2026-04-15 14:58:19', '2026-04-15 14:58:19'),
(36, 31, 'cash', 5950.00, NULL, '2026-04-18 09:53:00', '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(37, 32, 'cash', 3214.23, NULL, '2026-04-18 09:55:00', '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(38, 33, 'cash', 3660.00, NULL, '2026-04-18 09:59:00', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(39, 34, 'cash', 677.36, NULL, '2026-04-18 10:03:00', '2026-04-18 09:05:14', '2026-04-18 09:05:14'),
(40, 35, 'cash', 4027.36, NULL, '2026-04-18 12:21:00', '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(41, 36, 'cash', 10900.00, NULL, '2026-04-18 12:24:00', '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(42, 37, 'cash', 7901.73, NULL, '2026-04-18 12:33:00', '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(43, 38, 'cash', 4901.73, NULL, '2026-04-18 12:35:00', '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(44, 39, 'card', 16467.45, NULL, '2026-04-18 13:46:00', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(45, 40, 'cash', 1200.32, NULL, '2026-04-18 16:20:00', '2026-04-18 15:21:19', '2026-04-18 15:21:19'),
(46, 41, 'cash', 600.00, NULL, '2026-04-18 16:22:00', '2026-04-18 15:24:21', '2026-04-18 15:24:21'),
(47, 42, 'cash', 1200.00, NULL, '2026-04-18 16:44:00', '2026-04-18 15:45:41', '2026-04-18 15:45:41'),
(48, 43, 'card', 2365.00, NULL, '2026-04-18 17:29:00', '2026-04-18 16:54:59', '2026-04-18 16:54:59'),
(49, 44, 'card', 537.50, NULL, '2026-04-18 17:55:00', '2026-04-18 16:59:12', '2026-04-18 16:59:12'),
(50, 45, 'card', 3400.00, NULL, '2026-04-18 17:59:00', '2026-04-18 17:02:02', '2026-04-18 17:02:02'),
(51, 46, 'cash', 500.00, NULL, '2026-04-18 18:02:00', '2026-04-18 17:15:35', '2026-04-18 17:15:35'),
(52, 47, 'cash', 700.00, NULL, '2026-04-18 18:15:00', '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(53, 48, 'card', 3410.00, NULL, '2026-04-18 18:38:00', '2026-04-18 18:55:22', '2026-04-18 18:55:22'),
(54, 49, 'cash', 2150.00, NULL, '2026-04-20 09:15:00', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(55, 50, 'cash', 26910.00, NULL, '2026-04-20 09:27:00', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(56, 51, 'cash', 500.00, NULL, '2026-04-20 10:33:00', '2026-04-20 09:33:46', '2026-04-20 09:33:46'),
(57, 52, 'cash', 1100.00, NULL, '2026-04-20 10:41:00', '2026-04-20 09:42:47', '2026-04-20 09:42:47'),
(58, 53, 'cash', 8141.21, NULL, '2026-04-20 13:27:00', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(59, 54, 'cash', 9780.00, NULL, '2026-04-20 13:36:00', '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(60, 55, 'cash', 2500.00, NULL, '2026-04-20 13:50:00', '2026-04-20 13:03:54', '2026-04-20 13:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Permission name (e.g., inventory.manage)',
  `description` text DEFAULT NULL COMMENT 'Permission description',
  `module` varchar(50) NOT NULL COMMENT 'Module grouping (inventory, sales, procurement, reports)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `description`, `module`, `created_at`, `updated_at`) VALUES
(1, 'inventory.view', 'View inventory and stock levels', 'inventory', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(2, 'inventory.manage', 'Add, edit, and delete inventory items', 'inventory', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(3, 'inventory.adjust', 'Perform stock adjustments', 'inventory', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(4, 'inventory.approve_transfer', 'Approve stock transfers', 'inventory', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(5, 'inventory.view_reports', 'View inventory reports', 'inventory', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(6, 'sales.create', 'Process sales transactions', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(7, 'sales.view', 'View sales records', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(8, 'sales.approve_controlled_substance', 'Approve sales of controlled substances', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(9, 'sales.process_return', 'Process sales returns', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(10, 'sales.apply_discount', 'Apply discounts to sales', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(11, 'sales.view_reports', 'View sales reports', 'sales', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(12, 'procurement.create_po', 'Create purchase orders', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(13, 'procurement.approve_po', 'Approve purchase orders', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(14, 'procurement.receive_goods', 'Receive goods and create GRN', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(15, 'procurement.quality_check', 'Perform quality checks on received goods', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(16, 'procurement.manage_suppliers', 'Add, edit, and delete suppliers', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(17, 'procurement.view_reports', 'View procurement reports', 'procurement', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(18, 'drugs.view', 'View drug catalog', 'drugs', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(19, 'drugs.manage', 'Add, edit, and delete drugs', 'drugs', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(20, 'users.view', 'View user accounts', 'users', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(21, 'users.manage', 'Add, edit, and delete user accounts', 'users', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(22, 'users.assign_roles', 'Assign roles to users', 'users', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(23, 'branches.view', 'View branch information', 'branches', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(24, 'branches.manage', 'Add, edit, and delete branches', 'branches', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(25, 'reports.view_all', 'View all system reports', 'reports', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(26, 'reports.export', 'Export reports to PDF/Excel', 'reports', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(27, 'reports.financial', 'View financial reports', 'reports', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(28, 'settings.view', 'View system settings', 'settings', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(29, 'settings.manage', 'Modify system settings', 'settings', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(30, 'pos.offline_mode', 'Allow offline transactions', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(31, 'pos.cash_drawer', 'Access cash drawer', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(32, 'pos.void_transaction', 'Void completed sales', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(33, 'pos.price_override', 'Override selling prices', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(34, 'pos.reprint_receipt', 'Reprint receipts', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(35, 'pos.start_shift', 'Start a POS shift', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(36, 'pos.end_shift', 'End a POS shift', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(37, 'pos.view_shift_report', 'View shift reports', 'pos', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(38, 'dashboard.view', 'Access dashboard', 'dashboard', '2026-01-13 17:50:14', '2026-01-13 17:50:14');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_number` varchar(50) NOT NULL COMMENT 'Auto-generated PO number (PO-YYYY-MM-NNNN)',
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `order_date` date NOT NULL COMMENT 'Order date',
  `expected_delivery_date` date DEFAULT NULL COMMENT 'Expected delivery date',
  `status` enum('draft','pending_approval','approved','partially_received','completed','cancelled') NOT NULL DEFAULT 'draft' COMMENT 'PO status',
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Total order amount',
  `notes` text DEFAULT NULL COMMENT 'Additional notes',
  `approved_at` timestamp NULL DEFAULT NULL COMMENT 'Approval timestamp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`id`, `order_number`, `supplier_id`, `branch_id`, `created_by`, `approved_by`, `order_date`, `expected_delivery_date`, `status`, `total_amount`, `notes`, `approved_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'PO-202601-000001', 1, 1, 1, 1, '2026-01-23', '2026-01-25', 'approved', 201000.00, NULL, '2026-01-23 09:38:08', '2026-01-23 09:37:45', '2026-01-23 09:38:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `purchase_order_id` bigint(20) UNSIGNED NOT NULL,
  `drug_id` bigint(20) UNSIGNED NOT NULL,
  `quantity_ordered` int(11) NOT NULL COMMENT 'Quantity ordered',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Unit price',
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Line item subtotal (calculated)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_order_items`
--

INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `drug_id`, `quantity_ordered`, `unit_price`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 1, 5, 100, 2000.00, 200000.00, '2026-01-23 09:37:45', '2026-01-23 09:37:45'),
(2, 1, 14, 100, 10.00, 1000.00, '2026-01-23 09:37:45', '2026-01-23 09:37:45');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Role name (e.g., Super Admin, Pharmacist)',
  `description` text DEFAULT NULL COMMENT 'Role description',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'Full system access with all permissions', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(2, 'Pharmacist', 'Can approve controlled substances, prescriptions, and manage clinical operations', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(3, 'Store Manager', 'Can manage inventory, approve transfers and purchase orders', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(4, 'Sales Staff', 'Can process sales, view inventory, and handle customer transactions', '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(5, 'Cashier', NULL, '2026-01-13 17:04:30', '2026-01-13 17:04:30');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(2, 1, 2, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(3, 1, 3, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(4, 1, 4, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(5, 1, 5, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(6, 1, 6, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(7, 1, 7, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(8, 1, 8, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(9, 1, 9, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(10, 1, 10, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(11, 1, 11, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(12, 1, 12, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(13, 1, 13, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(14, 1, 14, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(15, 1, 15, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(16, 1, 16, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(17, 1, 17, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(18, 1, 18, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(19, 1, 19, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(20, 1, 20, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(21, 1, 21, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(22, 1, 22, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(23, 1, 23, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(24, 1, 24, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(25, 1, 25, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(26, 1, 26, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(27, 1, 27, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(28, 1, 28, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(29, 1, 29, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(30, 1, 30, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(31, 1, 31, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(32, 1, 32, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(33, 1, 33, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(34, 1, 34, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(35, 1, 35, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(36, 1, 36, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(37, 1, 37, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(38, 2, 1, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(39, 2, 2, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(40, 2, 5, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(41, 2, 6, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(42, 2, 7, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(43, 2, 8, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(44, 2, 9, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(45, 2, 10, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(46, 2, 11, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(47, 2, 12, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(48, 2, 14, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(49, 2, 15, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(50, 2, 17, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(51, 2, 18, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(52, 2, 19, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(53, 2, 25, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(54, 2, 26, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(55, 3, 1, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(56, 3, 2, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(57, 3, 3, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(58, 3, 4, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(59, 3, 5, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(60, 3, 6, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(61, 3, 7, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(62, 3, 9, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(63, 3, 10, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(64, 3, 11, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(65, 3, 12, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(66, 3, 13, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(67, 3, 14, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(68, 3, 15, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(69, 3, 16, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(70, 3, 17, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(71, 3, 18, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(72, 3, 19, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(73, 3, 20, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(74, 3, 23, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(75, 3, 25, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(76, 3, 26, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(77, 3, 27, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(78, 4, 18, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(80, 4, 6, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(81, 4, 7, '2026-01-10 17:52:43', '2026-01-10 17:52:43'),
(84, 5, 6, '2026-01-13 17:04:30', '2026-01-13 17:04:30'),
(85, 5, 7, '2026-01-13 17:04:30', '2026-01-13 17:04:30'),
(86, 5, 31, '2026-01-13 17:04:30', '2026-01-13 17:04:30'),
(87, 5, 34, '2026-01-13 17:04:30', '2026-01-13 17:04:30'),
(88, 1, 38, '2026-01-13 17:51:07', '2026-01-13 17:51:07'),
(89, 2, 38, '2026-01-13 17:51:07', '2026-01-13 17:51:07'),
(90, 3, 38, '2026-01-13 17:51:07', '2026-01-13 17:51:07'),
(91, 4, 1, '2026-01-13 17:51:07', '2026-01-13 17:51:07'),
(92, 4, 38, '2026-01-13 17:51:07', '2026-01-13 17:51:07'),
(93, 5, 38, '2026-01-13 17:51:43', '2026-01-13 17:51:43'),
(94, 5, 35, '2026-01-13 18:36:00', '2026-01-13 18:36:00'),
(95, 5, 36, '2026-01-13 18:36:00', '2026-01-13 18:36:00'),
(96, 5, 37, '2026-01-13 18:36:00', '2026-01-13 18:36:00'),
(97, 4, 9, '2026-01-13 19:29:22', '2026-01-13 19:29:22');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_number` varchar(50) NOT NULL COMMENT 'Auto-generated sale number (SAL-YYYY-MM-NNNNNN)',
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `sale_date` datetime NOT NULL COMMENT 'Date and time of sale',
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Subtotal before tax and discount',
  `tax_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Tax amount',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Discount amount',
  `discount_authorized_by` bigint(20) UNSIGNED DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL COMMENT 'Final total amount',
  `customer_name` varchar(255) DEFAULT NULL COMMENT 'Customer name (optional)',
  `customer_phone` varchar(20) DEFAULT NULL COMMENT 'Customer phone (for purchase history)',
  `prescription_number` varchar(100) DEFAULT NULL COMMENT 'Prescription number (required for Rx-only drugs)',
  `approved_by_pharmacist` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('completed','returned','partially_returned') NOT NULL DEFAULT 'completed' COMMENT 'Sale status',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `sale_number`, `branch_id`, `user_id`, `sale_date`, `subtotal`, `tax_amount`, `discount_amount`, `discount_authorized_by`, `total_amount`, `customer_name`, `customer_phone`, `prescription_number`, `approved_by_pharmacist`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'SAL-202601000001', 1, 1, '2026-01-10 21:56:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'returned', '2026-01-10 20:57:07', '2026-01-10 21:57:52', NULL),
(2, 'SAL-202601000002', 1, 1, '2026-01-10 22:13:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'returned', '2026-01-10 21:13:27', '2026-01-10 21:59:29', NULL),
(3, 'SAL-202601000003', 1, 1, '2026-01-10 22:31:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-10 21:31:41', '2026-01-10 21:31:41', NULL),
(4, 'SAL-202601000004', 1, 8, '2026-01-13 19:54:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 18:55:16', '2026-01-13 18:55:16', NULL),
(5, 'SAL-202601000005', 1, 8, '2026-01-13 19:55:00', 9600.00, 0.00, 0.00, NULL, 9600.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 19:01:33', '2026-01-13 19:01:33', NULL),
(6, 'SAL-202601000006', 1, 1, '2026-01-13 20:13:00', 4800.00, 0.00, 10.00, NULL, 4790.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 19:14:22', '2026-01-13 19:14:22', NULL),
(7, 'SAL-202601000007', 1, 8, '2026-01-13 20:25:00', 2400.00, 0.00, 10.00, NULL, 2390.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 19:25:32', '2026-01-13 19:25:32', NULL),
(8, 'SAL-202601000008', 1, 8, '2026-01-13 21:09:00', 2400.00, 0.00, 10.00, 1, 2390.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 20:10:14', '2026-01-13 20:10:14', NULL),
(9, 'SAL-202601000009', 1, 8, '2026-01-13 21:35:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 20:49:51', '2026-01-13 20:49:51', NULL),
(10, 'SAL-202601000010', 1, 8, '2026-01-13 21:50:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 20:51:06', '2026-01-13 20:51:06', NULL),
(11, 'SAL-202601000011', 1, 8, '2026-01-13 22:12:00', 2400.00, 0.00, 0.00, NULL, 2400.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-13 21:13:10', '2026-01-13 21:13:10', NULL),
(12, 'SAL-202601000012', 1, 1, '2026-01-23 10:30:00', 22000.00, 1650.00, 0.00, NULL, 23650.00, NULL, NULL, NULL, NULL, 'returned', '2026-01-23 09:32:18', '2026-01-23 09:34:56', NULL),
(13, 'SAL-202601000013', 7, 9, '2026-01-23 11:02:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-23 10:02:28', '2026-01-23 10:02:28', NULL),
(14, 'SAL-202601000014', 7, 9, '2026-01-24 00:39:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-23 23:39:49', '2026-01-23 23:39:49', NULL),
(15, 'SAL-202601000015', 7, 1, '2026-01-24 00:56:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-23 23:56:44', '2026-01-23 23:56:44', NULL),
(16, 'SAL-202601000016', 7, 9, '2026-01-24 01:02:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 00:02:55', '2026-01-24 00:02:55', NULL),
(17, 'SAL-202601000017', 7, 9, '2026-01-24 01:03:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 00:03:16', '2026-01-24 00:03:16', NULL),
(18, 'SAL-202601000018', 7, 9, '2026-01-24 01:03:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 00:04:09', '2026-01-24 00:04:09', NULL),
(19, 'SAL-202601000019', 7, 9, '2026-01-24 01:19:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 00:19:28', '2026-01-24 00:19:28', NULL),
(20, 'SAL-202601000020', 7, 9, '2026-01-24 01:58:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 00:59:01', '2026-01-24 00:59:01', NULL),
(21, 'SAL-202601000021', 7, 1, '2026-01-24 02:00:00', 12000.00, 900.00, 0.00, NULL, 12900.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 01:00:18', '2026-01-24 01:00:18', NULL),
(22, 'SAL-202601000022', 7, 1, '2026-01-24 21:08:00', 85000.00, 0.00, 0.00, NULL, 85000.00, NULL, NULL, NULL, NULL, 'partially_returned', '2026-01-24 20:12:27', '2026-01-24 20:56:53', NULL),
(23, 'SAL-202601000023', 7, 2, '2026-01-24 22:11:00', 850.00, 0.00, 0.00, NULL, 850.00, 'oma', '0814455865', NULL, NULL, 'completed', '2026-01-24 21:12:22', '2026-01-24 21:12:22', NULL),
(24, 'SAL-202601000024', 7, 2, '2026-01-25 00:28:00', 12000.00, 900.00, 1200.00, 1, 11700.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-24 23:30:07', '2026-01-24 23:30:07', NULL),
(25, 'SAL-202601000025', 7, 9, '2026-01-25 13:18:00', 41650.00, 0.00, 0.00, NULL, 41650.00, NULL, NULL, NULL, NULL, 'completed', '2026-01-25 12:23:07', '2026-01-25 12:23:07', NULL),
(26, 'SAL-202601000026', 7, 9, '2026-01-25 13:24:00', 27500.00, 2062.50, 0.00, NULL, 29562.50, NULL, NULL, NULL, NULL, 'completed', '2026-01-25 12:27:59', '2026-01-25 12:27:59', NULL),
(27, 'SAL-202604000001', 7, 1, '2026-04-14 13:22:00', 1120.00, 84.00, 0.00, NULL, 1204.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-14 12:25:23', '2026-04-14 12:25:23', NULL),
(28, 'SAL-202604000002', 7, 1, '2026-04-14 13:40:00', 1050.00, 0.00, 0.00, NULL, 1050.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-14 12:42:22', '2026-04-14 12:42:22', NULL),
(29, 'SAL-202604000003', 7, 1, '2026-04-14 15:48:00', 1700.00, 0.00, 0.00, NULL, 1700.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-14 14:57:32', '2026-04-14 14:57:32', NULL),
(30, 'SAL-202604000004', 7, 1, '2026-04-15 15:53:00', 3012.50, 225.94, 0.00, NULL, 3238.44, NULL, NULL, NULL, NULL, 'completed', '2026-04-15 14:58:19', '2026-04-15 14:58:19', NULL),
(31, 'SAL-202604000005', 7, 1, '2026-04-18 09:53:00', 5950.00, 0.00, 0.00, NULL, 5950.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 08:54:33', '2026-04-18 08:54:33', NULL),
(32, 'SAL-202604000006', 7, 1, '2026-04-18 09:55:00', 3214.23, 0.00, 0.00, NULL, 3214.23, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 08:59:56', '2026-04-18 08:59:56', NULL),
(33, 'SAL-202604000007', 7, 1, '2026-04-18 09:59:00', 3660.00, 0.00, 0.00, NULL, 3660.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 09:03:10', '2026-04-18 09:03:10', NULL),
(34, 'SAL-202604000008', 7, 1, '2026-04-18 10:03:00', 630.10, 47.26, 0.00, NULL, 677.36, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 09:05:14', '2026-04-18 09:05:14', NULL),
(35, 'SAL-202604000009', 7, 1, '2026-04-18 12:21:00', 3980.10, 47.26, 0.00, NULL, 4027.36, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 11:23:37', '2026-04-18 11:23:37', NULL),
(36, 'SAL-202604000010', 7, 1, '2026-04-18 12:24:00', 10900.00, 0.00, 0.00, NULL, 10900.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 11:30:40', '2026-04-18 11:30:40', NULL),
(37, 'SAL-202604000011', 7, 1, '2026-04-18 12:33:00', 7901.73, 0.00, 0.00, NULL, 7901.73, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 11:35:48', '2026-04-18 11:35:48', NULL),
(38, 'SAL-202604000012', 7, 1, '2026-04-18 12:35:00', 4901.73, 0.00, 0.00, NULL, 4901.73, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 11:38:26', '2026-04-18 11:38:26', NULL),
(39, 'SAL-202604000013', 7, 1, '2026-04-18 13:46:00', 16069.20, 398.25, 0.00, NULL, 16467.45, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 12:49:18', '2026-04-18 12:49:18', NULL),
(40, 'SAL-202604000014', 7, 1, '2026-04-18 16:20:00', 1200.32, 0.00, 0.00, NULL, 1200.32, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 15:21:19', '2026-04-18 15:21:19', NULL),
(41, 'SAL-202604000015', 7, 1, '2026-04-18 16:22:00', 600.00, 0.00, 0.00, NULL, 600.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 15:24:21', '2026-04-18 15:24:21', NULL),
(42, 'SAL-202604000016', 7, 1, '2026-04-18 16:44:00', 1200.00, 0.00, 0.00, NULL, 1200.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 15:45:41', '2026-04-18 15:45:41', NULL),
(43, 'SAL-202604000017', 7, 1, '2026-04-18 17:29:00', 2200.00, 165.00, 0.00, NULL, 2365.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 16:54:59', '2026-04-18 16:54:59', NULL),
(44, 'SAL-202604000018', 7, 1, '2026-04-18 17:55:00', 500.00, 37.50, 0.00, NULL, 537.50, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 16:59:12', '2026-04-18 16:59:12', NULL),
(45, 'SAL-202604000019', 7, 1, '2026-04-18 17:59:00', 3400.00, 0.00, 0.00, NULL, 3400.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 17:02:02', '2026-04-18 17:02:02', NULL),
(46, 'SAL-202604000020', 7, 1, '2026-04-18 18:02:00', 500.00, 0.00, 0.00, NULL, 500.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 17:15:35', '2026-04-18 17:15:35', NULL),
(47, 'SAL-202604000021', 7, 1, '2026-04-18 18:15:00', 700.00, 0.00, 0.00, NULL, 700.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 17:38:49', '2026-04-18 17:38:49', NULL),
(48, 'SAL-202604000022', 7, 1, '2026-04-18 18:38:00', 3410.00, 0.00, 0.00, NULL, 3410.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-18 18:55:22', '2026-04-18 18:55:22', NULL),
(49, 'SAL-202604000023', 7, 1, '2026-04-20 09:15:00', 2150.00, 0.00, 0.00, NULL, 2150.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 08:17:52', '2026-04-20 08:17:52', NULL),
(50, 'SAL-202604000024', 7, 1, '2026-04-20 09:27:00', 26910.00, 0.00, 0.00, NULL, 26910.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 08:34:59', '2026-04-20 08:34:59', NULL),
(51, 'SAL-202604000025', 7, 1, '2026-04-20 10:33:00', 500.00, 0.00, 0.00, NULL, 500.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 09:33:46', '2026-04-20 09:33:46', NULL),
(52, 'SAL-202604000026', 7, 1, '2026-04-20 10:41:00', 1100.00, 0.00, 0.00, NULL, 1100.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 09:42:47', '2026-04-20 09:42:47', NULL),
(53, 'SAL-202604000027', 7, 1, '2026-04-20 13:27:00', 8141.21, 0.00, 0.00, NULL, 8141.21, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 12:36:35', '2026-04-20 12:36:35', NULL),
(54, 'SAL-202604000028', 7, 1, '2026-04-20 13:36:00', 9780.00, 0.00, 0.00, NULL, 9780.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 12:37:59', '2026-04-20 12:37:59', NULL),
(55, 'SAL-202604000029', 7, 1, '2026-04-20 13:50:00', 2500.00, 0.00, 0.00, NULL, 2500.00, NULL, NULL, NULL, NULL, 'completed', '2026-04-20 13:03:54', '2026-04-20 13:03:54', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sale_items`
--

CREATE TABLE `sale_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `stock_item_id` bigint(20) UNSIGNED NOT NULL,
  `drug_id` bigint(20) UNSIGNED NOT NULL,
  `batch_number` varchar(100) NOT NULL COMMENT 'Batch number (denormalized for reporting)',
  `quantity` int(11) NOT NULL COMMENT 'Quantity sold',
  `quantity_returned` int(11) NOT NULL DEFAULT 0 COMMENT 'Quantity of this item that has been returned',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Unit selling price',
  `subtotal` decimal(12,2) NOT NULL COMMENT 'Line item subtotal',
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'VAT rate applied at time of sale',
  `vat_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'VAT amount for this line item',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sale_items`
--

INSERT INTO `sale_items` (`id`, `sale_id`, `stock_item_id`, `drug_id`, `batch_number`, `quantity`, `quantity_returned`, `unit_price`, `subtotal`, `vat_rate`, `vat_amount`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 16, '2012924', 1, 1, 2400.00, 2400.00, 0.00, 0.00, '2026-01-10 20:57:07', '2026-01-10 21:57:52'),
(2, 2, 1, 16, '2012924', 1, 1, 2400.00, 2400.00, 0.00, 0.00, '2026-01-10 21:13:27', '2026-01-10 21:59:29'),
(3, 3, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-10 21:31:41', '2026-01-10 21:31:41'),
(4, 4, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 18:55:16', '2026-01-13 18:55:16'),
(5, 5, 1, 16, '2012924', 4, 0, 2400.00, 9600.00, 0.00, 0.00, '2026-01-13 19:01:33', '2026-01-13 19:01:33'),
(6, 6, 1, 16, '2012924', 2, 0, 2400.00, 4800.00, 0.00, 0.00, '2026-01-13 19:14:22', '2026-01-13 19:14:22'),
(7, 7, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 19:25:32', '2026-01-13 19:25:32'),
(8, 8, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 20:10:14', '2026-01-13 20:10:14'),
(9, 9, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 20:49:51', '2026-01-13 20:49:51'),
(10, 10, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 20:51:06', '2026-01-13 20:51:06'),
(11, 11, 1, 16, '2012924', 1, 0, 2400.00, 2400.00, 0.00, 0.00, '2026-01-13 21:13:10', '2026-01-13 21:13:10'),
(12, 12, 2, 18, 'BR9010', 1, 1, 22000.00, 22000.00, 7.50, 1650.00, '2026-01-23 09:32:18', '2026-01-23 09:34:56'),
(13, 13, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-23 10:02:28', '2026-01-23 10:02:28'),
(14, 14, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-23 23:39:49', '2026-01-23 23:39:49'),
(15, 15, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-23 23:56:44', '2026-01-23 23:56:44'),
(16, 16, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 00:02:55', '2026-01-24 00:02:55'),
(17, 17, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 00:03:16', '2026-01-24 00:03:16'),
(18, 18, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 00:04:09', '2026-01-24 00:04:09'),
(19, 19, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 00:19:28', '2026-01-24 00:19:28'),
(20, 20, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 00:59:01', '2026-01-24 00:59:01'),
(21, 21, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 01:00:18', '2026-01-24 01:00:18'),
(22, 22, 5, 20, '0835', 100, 50, 850.00, 85000.00, 0.00, 0.00, '2026-01-24 20:12:27', '2026-01-24 20:56:53'),
(23, 23, 5, 20, '0835', 1, 0, 850.00, 850.00, 0.00, 0.00, '2026-01-24 21:12:22', '2026-01-24 21:12:22'),
(24, 24, 3, 18, '12345', 1, 0, 12000.00, 12000.00, 7.50, 900.00, '2026-01-24 23:30:07', '2026-01-24 23:30:07'),
(25, 25, 5, 20, '0835', 49, 0, 850.00, 41650.00, 0.00, 0.00, '2026-01-25 12:23:07', '2026-01-25 12:23:07'),
(26, 26, 4, 20, '0833', 10, 0, 350.00, 3500.00, 7.50, 262.50, '2026-01-25 12:27:59', '2026-01-25 12:27:59'),
(27, 26, 3, 18, '12345', 2, 0, 12000.00, 24000.00, 7.50, 1800.00, '2026-01-25 12:27:59', '2026-01-25 12:27:59'),
(28, 27, 71, 90, '3333CM', 1, 0, 300.00, 300.00, 7.50, 22.50, '2026-04-14 12:25:23', '2026-04-14 12:25:23'),
(29, 27, 57, 75, 'B260224', 1, 0, 820.00, 820.00, 7.50, 61.50, '2026-04-14 12:25:23', '2026-04-14 12:25:23'),
(30, 28, 443, 462, 'l6026566aw', 1, 0, 650.00, 650.00, 0.00, 0.00, '2026-04-14 12:42:22', '2026-04-14 12:42:22'),
(31, 28, 491, 508, 'MC1023', 2, 0, 200.00, 400.00, 0.00, 0.00, '2026-04-14 12:42:22', '2026-04-14 12:42:22'),
(32, 29, 497, 513, '2025307', 5, 0, 100.00, 500.00, 0.00, 0.00, '2026-04-14 14:57:32', '2026-04-14 14:57:32'),
(33, 29, 530, 547, '029', 1, 0, 1200.00, 1200.00, 0.00, 0.00, '2026-04-14 14:57:32', '2026-04-14 14:57:32'),
(34, 30, 301, 318, '8935212810845', 1, 0, 2200.00, 2200.00, 7.50, 165.00, '2026-04-15 14:58:19', '2026-04-15 14:58:19'),
(35, 30, 54, 72, 'ASP-0126', 1, 0, 812.50, 812.50, 7.50, 60.94, '2026-04-15 14:58:19', '2026-04-15 14:58:19'),
(36, 31, 977, 519, '12/10/15', 1, 0, 450.00, 450.00, 0.00, 0.00, '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(37, 31, 502, 518, '06/6D', 1, 0, 450.00, 450.00, 0.00, 0.00, '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(38, 31, 799, 800, 'CM24250', 1, 0, 950.00, 950.00, 0.00, 0.00, '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(39, 31, 542, 559, '20250301', 1, 0, 4100.00, 4100.00, 0.00, 0.00, '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(40, 32, 444, 463, 'az5', 1, 0, 501.73, 501.73, 0.00, 0.00, '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(41, 32, 143, 162, 'A250288', 1, 0, 950.00, 950.00, 0.00, 0.00, '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(42, 32, 276, 293, '1200', 1, 0, 812.50, 812.50, 0.00, 0.00, '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(43, 32, 398, 415, 'CE07655', 1, 0, 950.00, 950.00, 0.00, 0.00, '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(44, 33, 551, 568, '240721', 1, 0, 1250.00, 1250.00, 0.00, 0.00, '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(45, 33, 165, 184, 'L569E', 1, 0, 1050.00, 1050.00, 0.00, 0.00, '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(46, 33, 352, 368, 'GT0225040', 1, 0, 550.00, 550.00, 0.00, 0.00, '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(47, 33, 378, 395, '6156000152806', 1, 0, 410.00, 410.00, 0.00, 0.00, '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(48, 33, 811, 637, 'M01240701', 1, 0, 400.00, 400.00, 0.00, 0.00, '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(49, 34, 58, 76, '063208', 1, 0, 630.10, 630.10, 7.50, 47.26, '2026-04-18 09:05:14', '2026-04-18 09:05:14'),
(50, 35, 980, 988, '14', 9, 0, 250.00, 2250.00, 0.00, 0.00, '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(51, 35, 979, 987, '2014725', 1, 0, 1100.00, 1100.00, 0.00, 0.00, '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(52, 35, 58, 76, '063208', 1, 0, 630.10, 630.10, 7.50, 47.26, '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(53, 36, 927, 922, 'NG6ZP', 1, 0, 6000.00, 6000.00, 0.00, 0.00, '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(54, 36, 460, 477, 'vv-0326', 6, 0, 500.00, 3000.00, 0.00, 0.00, '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(55, 36, 969, 970, 'ASP0226', 1, 0, 750.00, 750.00, 0.00, 0.00, '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(56, 36, 531, 548, '6156000346076', 1, 0, 1150.00, 1150.00, 0.00, 0.00, '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(57, 37, 205, 224, '062A2535X', 2, 0, 425.00, 850.00, 0.00, 0.00, '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(58, 37, 800, 801, 'M25I012', 3, 0, 2100.00, 6300.00, 0.00, 0.00, '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(59, 37, 444, 463, 'az5', 1, 0, 501.73, 501.73, 0.00, 0.00, '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(60, 37, 980, 988, '14', 1, 0, 250.00, 250.00, 0.00, 0.00, '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(61, 38, 205, 224, '062A2535X', 2, 0, 425.00, 850.00, 0.00, 0.00, '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(62, 38, 618, 633, '202505006', 3, 0, 1100.00, 3300.00, 0.00, 0.00, '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(63, 38, 444, 463, 'az5', 1, 0, 501.73, 501.73, 0.00, 0.00, '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(64, 38, 980, 988, '14', 1, 0, 250.00, 250.00, 0.00, 0.00, '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(65, 39, 19, 35, 'AC325Q', 3, 0, 1770.00, 5310.00, 7.50, 398.25, '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(66, 39, 472, 488, '3131WIC', 1, 0, 3300.00, 3300.00, 0.00, 0.00, '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(67, 39, 988, 995, '711', 1, 0, 1000.00, 1000.00, 0.00, 0.00, '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(68, 39, 426, 443, '854186-2', 2, 0, 2979.60, 5959.20, 0.00, 0.00, '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(69, 39, 482, 498, 'AZ25', 1, 0, 500.00, 500.00, 0.00, 0.00, '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(70, 40, 442, 461, 'bf233', 2, 0, 600.16, 1200.32, 0.00, 0.00, '2026-04-18 15:21:19', '2026-04-18 15:21:19'),
(71, 41, 621, 636, '250505', 1, 0, 600.00, 600.00, 0.00, 0.00, '2026-04-18 15:24:21', '2026-04-18 15:24:21'),
(72, 42, 544, 561, 'KK135', 1, 0, 600.00, 600.00, 0.00, 0.00, '2026-04-18 15:45:41', '2026-04-18 15:45:41'),
(73, 42, 246, 261, '5A158005', 4, 0, 150.00, 600.00, 0.00, 0.00, '2026-04-18 15:45:41', '2026-04-18 15:45:41'),
(74, 43, 297, 314, 'A2-1655', 1, 0, 2200.00, 2200.00, 7.50, 165.00, '2026-04-18 16:54:59', '2026-04-18 16:54:59'),
(75, 44, 59, 77, 'SOSA11', 1, 0, 500.00, 500.00, 7.50, 37.50, '2026-04-18 16:59:12', '2026-04-18 16:59:12'),
(76, 45, 127, 146, '5113W', 2, 0, 1700.00, 3400.00, 0.00, 0.00, '2026-04-18 17:02:02', '2026-04-18 17:02:02'),
(77, 46, 558, 575, '5373552', 1, 0, 450.00, 450.00, 0.00, 0.00, '2026-04-18 17:15:35', '2026-04-18 17:15:35'),
(78, 46, 510, 527, '53150324HI', 2, 0, 25.00, 50.00, 0.00, 0.00, '2026-04-18 17:15:35', '2026-04-18 17:15:35'),
(79, 47, 759, 759, '250701001', 2, 0, 100.00, 200.00, 0.00, 0.00, '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(80, 47, 581, 598, '344248', 1, 0, 450.00, 450.00, 0.00, 0.00, '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(81, 47, 506, 523, '12/2N', 2, 0, 25.00, 50.00, 0.00, 0.00, '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(82, 48, 206, 225, 'B41402', 2, 0, 1680.00, 3360.00, 0.00, 0.00, '2026-04-18 18:55:22', '2026-04-18 18:55:22'),
(83, 48, 511, 528, '52810324HI', 2, 0, 25.00, 50.00, 0.00, 0.00, '2026-04-18 18:55:22', '2026-04-18 18:55:22'),
(84, 49, 460, 477, 'vv-0326', 3, 0, 500.00, 1500.00, 0.00, 0.00, '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(85, 49, 980, 988, '14', 1, 0, 250.00, 250.00, 0.00, 0.00, '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(86, 49, 188, 207, 'SM250639', 1, 0, 300.00, 300.00, 0.00, 0.00, '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(87, 49, 509, 526, 'OCN0351824', 1, 0, 50.00, 50.00, 0.00, 0.00, '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(88, 49, 511, 528, '52810324HI', 2, 0, 25.00, 50.00, 0.00, 0.00, '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(89, 50, 583, 600, '344226', 2, 0, 500.00, 1000.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(90, 50, 581, 598, '344248', 3, 0, 450.00, 1350.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(91, 50, 133, 152, '002', 3, 0, 450.00, 1350.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(92, 50, 560, 577, 'T3ABC089', 2, 0, 200.00, 400.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(93, 50, 352, 368, 'GT0225040', 3, 0, 550.00, 1650.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(94, 50, 115, 134, '2509014B', 2, 0, 4480.00, 8960.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(95, 50, 643, 658, 'M25G004', 2, 0, 3000.00, 6000.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(96, 50, 831, 831, 'P211025', 1, 0, 6200.00, 6200.00, 0.00, 0.00, '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(97, 51, 481, 497, 'AK2', 1, 0, 500.00, 500.00, 0.00, 0.00, '2026-04-20 09:33:46', '2026-04-20 09:33:46'),
(98, 52, 979, 987, '2014725', 1, 0, 1100.00, 1100.00, 0.00, 0.00, '2026-04-20 09:42:47', '2026-04-20 09:42:47'),
(99, 53, 701, 712, '2504034A', 1, 0, 4650.00, 4650.00, 0.00, 0.00, '2026-04-20 12:36:35', '2026-04-20 12:36:35'),
(100, 53, 504, 521, 'ZH01250812', 1, 0, 1300.00, 1300.00, 0.00, 0.00, '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(101, 53, 445, 464, 'az2', 1, 0, 501.73, 501.73, 0.00, 0.00, '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(102, 53, 446, 465, 'ak6', 2, 0, 594.74, 1189.48, 0.00, 0.00, '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(103, 53, 980, 988, '14', 2, 0, 250.00, 500.00, 0.00, 0.00, '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(104, 54, 814, 814, '25I30E1', 1, 0, 3800.00, 3800.00, 0.00, 0.00, '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(105, 54, 115, 134, '2509014B', 1, 0, 4480.00, 4480.00, 0.00, 0.00, '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(106, 54, 564, 580, 'N-3382', 1, 0, 1050.00, 1050.00, 0.00, 0.00, '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(107, 54, 502, 518, '06/6D', 1, 0, 450.00, 450.00, 0.00, 0.00, '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(108, 55, 708, 718, 'C0126001', 1, 0, 1500.00, 1500.00, 0.00, 0.00, '2026-04-20 13:03:54', '2026-04-20 13:03:54'),
(109, 55, 563, 581, '316250505', 1, 0, 500.00, 500.00, 0.00, 0.00, '2026-04-20 13:03:54', '2026-04-20 13:03:54'),
(110, 55, 482, 498, 'AZ25', 1, 0, 500.00, 500.00, 0.00, 0.00, '2026-04-20 13:03:54', '2026-04-20 13:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `sale_returns`
--

CREATE TABLE `sale_returns` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `return_number` varchar(50) NOT NULL COMMENT 'Unique return reference number',
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `processed_by` bigint(20) UNSIGNED NOT NULL,
  `authorized_by` bigint(20) UNSIGNED NOT NULL,
  `return_date` datetime NOT NULL COMMENT 'Date and time of return',
  `refund_amount` decimal(12,2) NOT NULL COMMENT 'Total refund amount',
  `refund_method` varchar(50) NOT NULL COMMENT 'Refund payment method: cash, original_payment, store_credit',
  `reason` text NOT NULL COMMENT 'Reason for return',
  `status` enum('completed','voided') NOT NULL DEFAULT 'completed',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sale_returns`
--

INSERT INTO `sale_returns` (`id`, `return_number`, `sale_id`, `branch_id`, `processed_by`, `authorized_by`, `return_date`, `refund_amount`, `refund_method`, `reason`, `status`, `created_at`, `updated_at`) VALUES
(1, 'RET-20260110-0001', 1, 1, 1, 1, '2026-01-10 22:57:52', 2400.00, 'cash', 'test', 'completed', '2026-01-10 21:57:52', '2026-01-10 21:57:52'),
(2, 'RET-20260110-0002', 2, 1, 1, 1, '2026-01-10 22:59:29', 2400.00, 'cash', 'rewer', 'completed', '2026-01-10 21:59:29', '2026-01-10 21:59:29'),
(3, 'RET-20260123-0001', 12, 1, 1, 1, '2026-01-23 10:34:56', 22000.00, 'cash', 'Bad product', 'completed', '2026-01-23 09:34:56', '2026-01-23 09:34:56'),
(4, 'RET-20260124-0001', 22, 7, 2, 1, '2026-01-24 21:56:53', 42500.00, 'cash', 'bad packaging', 'completed', '2026-01-24 20:56:53', '2026-01-24 20:56:53');

-- --------------------------------------------------------

--
-- Table structure for table `sale_return_items`
--

CREATE TABLE `sale_return_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_return_id` bigint(20) UNSIGNED NOT NULL,
  `sale_item_id` bigint(20) UNSIGNED NOT NULL,
  `stock_item_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL COMMENT 'Quantity being returned',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Unit price at time of sale',
  `refund_amount` decimal(10,2) NOT NULL COMMENT 'Refund for this item',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sale_return_items`
--

INSERT INTO `sale_return_items` (`id`, `sale_return_id`, `sale_item_id`, `stock_item_id`, `quantity`, `unit_price`, `refund_amount`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 2400.00, 2400.00, '2026-01-10 21:57:52', '2026-01-10 21:57:52'),
(2, 2, 2, 1, 1, 2400.00, 2400.00, '2026-01-10 21:59:29', '2026-01-10 21:59:29'),
(3, 3, 12, 2, 1, 22000.00, 22000.00, '2026-01-23 09:34:56', '2026-01-23 09:34:56'),
(4, 4, 22, 5, 50, 850.00, 42500.00, '2026-01-24 20:56:53', '2026-01-24 20:56:53');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_items`
--

CREATE TABLE `stock_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `drug_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `batch_number` varchar(100) NOT NULL COMMENT 'Manufacturer batch/lot number',
  `manufacturing_date` date DEFAULT NULL COMMENT 'Manufacturing date',
  `expiry_date` date NOT NULL COMMENT 'Expiry date - CRITICAL for FEFO',
  `purchase_price` decimal(10,2) NOT NULL COMMENT 'Unit purchase price',
  `selling_price` decimal(10,2) NOT NULL COMMENT 'Unit selling price',
  `vat_applicable` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether VAT applies to this item',
  `quantity_available` int(11) NOT NULL DEFAULT 0 COMMENT 'Current available quantity',
  `minimum_stock_level` int(11) NOT NULL DEFAULT 0 COMMENT 'Minimum stock alert threshold',
  `reorder_point` int(11) NOT NULL DEFAULT 0 COMMENT 'Reorder point threshold',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ;

--
-- Dumping data for table `stock_items`
--

INSERT INTO `stock_items` (`id`, `drug_id`, `branch_id`, `batch_number`, `manufacturing_date`, `expiry_date`, `purchase_price`, `selling_price`, `vat_applicable`, `quantity_available`, `minimum_stock_level`, `reorder_point`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 16, 1, '2012924', '2024-09-30', '2026-04-25', 2000.00, 2400.00, 0, 0, 0, 0, '2026-01-10 19:46:16', '2026-04-18 09:33:09', NULL),
(2, 18, 1, 'BR9010', NULL, '2030-10-23', 20000.00, 22000.00, 1, 130, 20, 10, '2026-01-23 09:29:31', '2026-01-23 09:34:56', NULL),
(3, 18, 7, '12345', NULL, '2030-01-30', 10000.00, 12000.00, 1, 38, 0, 0, '2026-01-23 10:01:19', '2026-01-25 12:27:59', NULL),
(4, 20, 7, '0833', '2025-01-01', '2026-11-24', 200.00, 350.00, 1, 40, 20, 10, '2026-01-24 19:52:55', '2026-01-25 12:27:59', NULL),
(5, 20, 7, '0835', NULL, '2026-11-04', 500.00, 850.00, 0, 0, 30, 10, '2026-01-24 19:58:24', '2026-01-25 12:23:07', NULL),
(6, 22, 7, '1A101225', NULL, '2026-12-09', 2600.00, 3380.00, 1, 5, 2, 0, '2026-03-28 12:08:14', '2026-03-28 12:08:14', NULL),
(7, 23, 7, 'DSC-169', NULL, '2028-02-12', 1150.00, 1500.00, 1, 5, 2, 0, '2026-03-28 12:12:21', '2026-03-28 12:12:21', NULL),
(8, 24, 7, '708D', NULL, '2028-02-09', 1150.00, 1500.00, 0, 5, 2, 0, '2026-03-28 12:18:54', '2026-03-28 12:18:54', NULL),
(9, 25, 7, 'NBSJ20230910', NULL, '2026-09-10', 866.70, 1130.00, 1, 6, 2, 0, '2026-03-28 12:25:39', '2026-03-28 12:25:39', NULL),
(10, 26, 7, 'SASC202502067', NULL, '2028-02-27', 866.70, 1130.00, 1, 3, 2, 0, '2026-03-28 12:28:39', '2026-03-28 12:28:39', NULL),
(11, 27, 7, 'SRSF202411065', NULL, '2027-06-11', 866.70, 1130.00, 1, 3, 2, 0, '2026-03-28 12:31:41', '2026-03-28 12:31:41', NULL),
(12, 28, 7, 'BN21', NULL, '2027-05-12', 4083.33, 5300.00, 1, 6, 2, 0, '2026-03-28 12:37:34', '2026-03-28 12:37:34', NULL),
(13, 29, 7, '11', NULL, '2027-06-30', 2833.33, 3690.00, 1, 6, 2, 0, '2026-03-28 12:47:41', '2026-03-28 12:47:41', NULL),
(14, 30, 7, 'ZTC0852452', NULL, '2026-12-13', 4375.00, 5690.00, 1, 4, 2, 0, '2026-03-28 12:53:51', '2026-03-28 12:53:51', NULL),
(15, 31, 7, '26097', NULL, '2027-08-31', 900.00, 1170.00, 1, 20, 2, 0, '2026-03-28 12:57:48', '2026-03-28 12:57:48', NULL),
(16, 33, 7, 'L51345', NULL, '2028-08-24', 1125.00, 1470.00, 1, 4, 2, 0, '2026-03-28 13:02:52', '2026-03-28 13:02:52', NULL),
(17, 32, 7, '202812', NULL, '2029-12-02', 2083.33, 2708.33, 1, 3, 1, 0, '2026-03-28 13:03:32', '2026-03-28 13:03:32', NULL),
(18, 34, 7, '245187', NULL, '2029-12-02', 2083.33, 2708.33, 1, 3, 1, 0, '2026-03-28 13:06:58', '2026-03-28 13:06:58', NULL),
(19, 35, 7, 'AC325Q', NULL, '2029-11-21', 1360.00, 1770.00, 1, 47, 2, 0, '2026-03-28 13:11:09', '2026-04-18 12:49:18', NULL),
(20, 36, 7, '7842', NULL, '2029-12-02', 2083.33, 2708.30, 1, 3, 1, 0, '2026-03-28 13:12:31', '2026-03-28 13:12:31', NULL),
(21, 37, 7, '10GZ2XS', NULL, '2027-03-11', 625.00, 820.00, 1, 24, 2, 0, '2026-03-28 13:17:15', '2026-03-28 13:17:15', NULL),
(22, 38, 7, '15105A2022', NULL, '2028-12-15', 4791.67, 6230.00, 1, 12, 2, 0, '2026-03-28 13:27:05', '2026-03-28 13:27:05', NULL),
(23, 40, 7, '658', NULL, '2029-12-02', 2083.33, 2708.30, 1, 3, 1, 0, '2026-03-28 13:32:27', '2026-03-28 13:32:27', NULL),
(24, 39, 7, '60441478F', NULL, '2027-05-13', 3866.67, 5030.00, 1, 6, 2, 0, '2026-03-28 13:34:44', '2026-03-28 13:34:44', NULL),
(25, 41, 7, '41262417SP', NULL, '2027-03-12', 4166.66, 5400.00, 1, 1, 1, 0, '2026-03-28 13:38:06', '2026-03-28 13:38:06', NULL),
(26, 42, 7, '030226N', NULL, '2028-02-01', 1125.00, 1470.00, 1, 12, 2, 0, '2026-03-28 13:41:41', '2026-03-28 13:41:41', NULL),
(27, 44, 7, '300126N', NULL, '2028-01-30', 2875.00, 3740.00, 1, 4, 2, 0, '2026-03-28 13:47:43', '2026-03-28 13:47:43', NULL),
(28, 45, 7, '42114617SP', NULL, '2029-12-12', 4166.66, 5400.00, 1, 1, 1, 0, '2026-03-28 13:47:43', '2026-03-28 13:47:43', NULL),
(29, 46, 7, '42921617SP', NULL, '2029-12-02', 4166.66, 5400.00, 1, 2, 1, 0, '2026-03-28 13:52:21', '2026-03-28 13:52:21', NULL),
(30, 47, 7, '0', NULL, '2028-03-06', 1104.17, 1440.00, 1, 24, 2, 0, '2026-03-28 13:54:12', '2026-03-28 13:54:12', NULL),
(31, 49, 7, 'Z260226A3', NULL, '2026-08-25', 875.00, 1140.00, 1, 10, 2, 0, '2026-03-28 14:07:16', '2026-03-28 14:07:16', NULL),
(32, 48, 7, '40510217SP', NULL, '2029-12-02', 4166.66, 5400.00, 1, 2, 1, 0, '2026-03-28 14:08:58', '2026-03-28 14:08:58', NULL),
(33, 50, 7, 'DOM17032025', NULL, '2027-03-16', 479.17, 625.00, 1, 48, 2, 0, '2026-03-28 14:13:07', '2026-03-28 14:13:07', NULL),
(34, 51, 7, 'ICO25197-1', NULL, '2030-12-02', 2666.66, 3470.00, 1, 2, 1, 0, '2026-03-28 14:13:25', '2026-03-28 14:13:25', NULL),
(35, 52, 7, 'IG25277-1', NULL, '2030-12-02', 2666.66, 3470.00, 1, 2, 1, 0, '2026-03-28 14:15:43', '2026-03-28 14:15:43', NULL),
(36, 53, 7, 'DYN25332-1', NULL, '2030-12-12', 2666.66, 3470.00, 1, 1, 1, 0, '2026-03-28 14:18:22', '2026-03-28 14:18:22', NULL),
(37, 54, 7, '10GT2T1', NULL, '2027-02-05', 1000.00, 1300.00, 1, 24, 2, 0, '2026-03-28 14:19:58', '2026-03-28 14:19:58', NULL),
(38, 55, 7, 'ONL25342-1', NULL, '2030-12-12', 2666.66, 3470.00, 1, 1, 1, 0, '2026-03-28 14:20:34', '2026-03-28 14:20:34', NULL),
(39, 56, 7, 'ABH4651', NULL, '2027-09-30', 3000.00, 3900.00, 1, 6, 2, 0, '2026-03-28 14:25:34', '2026-03-28 14:25:34', NULL),
(40, 57, 7, '53663994', NULL, '2028-12-12', 5000.00, 6500.00, 1, 2, 1, 0, '2026-03-28 14:26:48', '2026-03-28 14:26:48', NULL),
(41, 58, 7, '60411478', NULL, '2027-05-10', 3350.00, 4360.00, 1, 5, 2, 0, '2026-03-28 14:30:06', '2026-03-28 14:30:06', NULL),
(42, 59, 7, '53054294', NULL, '2028-01-12', 5000.00, 6500.00, 1, 2, 1, 0, '2026-03-28 14:30:55', '2026-03-28 14:30:55', NULL),
(43, 61, 7, '54127494', NULL, '2028-12-12', 4500.00, 5850.00, 1, 1, 1, 0, '2026-03-28 14:34:09', '2026-03-28 14:34:09', NULL),
(44, 60, 7, 'B130825', NULL, '2028-07-30', 1416.67, 1850.00, 1, 6, 2, 0, '2026-03-28 14:34:15', '2026-03-28 14:34:15', NULL),
(45, 63, 7, '54062694', NULL, '2028-10-12', 4500.00, 5850.00, 1, 1, 1, 0, '2026-03-28 14:38:42', '2026-03-28 14:38:42', NULL),
(46, 62, 7, '181', NULL, '2029-01-21', 1625.00, 2120.00, 1, 6, 2, 0, '2026-03-28 14:38:54', '2026-03-28 14:38:54', NULL),
(47, 64, 7, 'ABJ4770', NULL, '2028-02-28', 1625.00, 2120.00, 1, 12, 2, 0, '2026-03-28 14:42:19', '2026-03-28 14:42:19', NULL),
(48, 65, 7, '60291478F', NULL, '2027-04-29', 1750.00, 2280.00, 1, 6, 2, 0, '2026-03-28 14:49:55', '2026-03-28 14:49:55', NULL),
(49, 67, 7, '20260403', NULL, '2027-05-05', 2416.66, 3145.00, 1, 6, 1, 0, '2026-03-29 14:15:54', '2026-03-29 14:15:54', NULL),
(50, 68, 7, '1002261632027', NULL, '2029-02-12', 1583.33, 2050.00, 1, 3, 1, 0, '2026-03-29 14:19:45', '2026-03-29 14:19:45', NULL),
(51, 69, 7, '0702261809018', NULL, '2029-06-02', 1583.33, 2050.00, 1, 3, 1, 0, '2026-03-29 14:22:16', '2026-03-29 14:22:16', NULL),
(52, 70, 7, '254441', NULL, '2028-10-30', 2166.66, 2820.00, 1, 6, 1, 0, '2026-03-29 14:25:37', '2026-03-29 14:25:37', NULL),
(53, 71, 7, '50620386E0', NULL, '2027-09-12', 1583.33, 2060.00, 1, 6, 1, 0, '2026-03-29 14:28:43', '2026-03-29 14:28:43', NULL),
(54, 72, 7, 'ASP-0126', NULL, '2029-01-12', 625.00, 812.50, 1, 3, 1, 0, '2026-03-29 14:31:32', '2026-04-15 14:58:19', NULL),
(55, 73, 7, '100017', NULL, '2028-04-12', 833.33, 1090.00, 1, 6, 1, 0, '2026-03-29 14:34:21', '2026-03-29 14:34:21', NULL),
(56, 74, 7, 'B260224', NULL, '2029-02-02', 625.00, 820.00, 1, 4, 1, 0, '2026-03-29 14:38:34', '2026-03-29 14:38:34', NULL),
(57, 75, 7, 'B260224', NULL, '2029-02-12', 625.00, 820.00, 1, 3, 1, 0, '2026-03-29 14:41:26', '2026-04-14 12:25:23', NULL),
(58, 76, 7, '063208', NULL, '2026-07-12', 479.16, 630.10, 1, 10, 1, 0, '2026-03-29 14:47:36', '2026-04-18 11:23:37', NULL),
(59, 77, 7, 'SOSA11', NULL, '2026-12-12', 383.33, 500.00, 1, 11, 1, 0, '2026-03-29 14:50:23', '2026-04-18 16:59:12', NULL),
(60, 78, 7, 'SOSA12', NULL, '2026-12-12', 383.33, 500.00, 1, 12, 1, 0, '2026-03-29 14:52:34', '2026-03-29 14:52:34', NULL),
(61, 79, 7, '1050033491', NULL, '2026-10-09', 916.66, 1200.00, 1, 12, 1, 0, '2026-03-29 14:55:12', '2026-03-29 14:55:12', NULL),
(62, 80, 7, '1050023401', NULL, '2026-12-12', 916.66, 1200.00, 1, 12, 1, 0, '2026-03-29 14:58:34', '2026-03-29 14:58:34', NULL),
(63, 81, 7, 'Z280226A1', NULL, '2026-11-27', 1330.00, 1730.00, 1, 10, 1, 0, '2026-03-29 15:01:42', '2026-03-29 15:01:42', NULL),
(64, 82, 7, 'FAMI45', NULL, '2028-12-12', 2666.66, 3200.00, 1, 6, 1, 0, '2026-03-29 15:13:29', '2026-03-29 15:13:29', NULL),
(65, 83, 7, 'FAMI44', NULL, '2030-12-12', 1875.00, 2250.00, 1, 8, 1, 0, '2026-03-29 15:22:17', '2026-03-29 15:22:17', NULL),
(66, 84, 7, '20251218', NULL, '2027-12-12', 666.66, 870.00, 1, 12, 2, 0, '2026-03-29 15:25:23', '2026-03-29 15:25:23', NULL),
(67, 86, 7, 'BESEN01', NULL, '2030-12-12', 1666.60, 2170.00, 1, 6, 1, 0, '2026-03-29 16:33:12', '2026-03-29 16:33:12', NULL),
(68, 87, 7, '4455', NULL, '2029-01-01', 1500.00, 1950.00, 1, 6, 1, 0, '2026-03-29 16:41:48', '2026-03-29 16:41:48', NULL),
(69, 88, 7, 'MYG01', NULL, '2028-12-12', 1666.60, 2170.00, 1, 6, 1, 0, '2026-03-29 16:44:39', '2026-03-29 16:44:39', NULL),
(70, 89, 7, '20260131', NULL, '2028-12-12', 583.33, 760.00, 1, 6, 1, 0, '2026-03-29 16:47:44', '2026-03-29 16:47:44', NULL),
(71, 90, 7, '3333CM', NULL, '2028-12-12', 250.00, 300.00, 1, 35, 5, 0, '2026-03-29 16:51:28', '2026-04-14 12:25:23', NULL),
(72, 91, 7, 'A40690', NULL, '2029-04-12', 1805.00, 2550.00, 0, 30, 5, 0, '2026-04-03 09:32:14', '2026-04-03 09:32:14', NULL),
(73, 92, 7, 'T4925', NULL, '2030-09-12', 900.00, 1260.00, 0, 3, 1, 0, '2026-04-03 09:38:37', '2026-04-03 09:38:37', NULL),
(74, 93, 7, 'ARF-03', NULL, '2027-07-12', 1020.00, 1430.00, 0, 5, 1, 0, '2026-04-03 09:42:46', '2026-04-03 09:42:46', NULL),
(75, 94, 7, '250115', NULL, '2027-12-12', 280.00, 400.00, 0, 10, 2, 0, '2026-04-03 09:48:47', '2026-04-03 09:48:47', NULL),
(76, 95, 7, 'A40885', NULL, '2029-05-12', 3640.00, 5100.00, 0, 3, 1, 0, '2026-04-03 09:55:33', '2026-04-03 09:55:33', NULL),
(77, 96, 7, 'A41348', NULL, '2027-09-12', 2060.00, 2900.00, 0, 10, 2, 0, '2026-04-03 10:02:38', '2026-04-03 10:02:38', NULL),
(78, 97, 7, '0907225', NULL, '2028-04-12', 460.00, 650.00, 0, 10, 2, 0, '2026-04-03 10:06:13', '2026-04-03 10:06:13', NULL),
(79, 98, 7, '2090625', NULL, '2028-05-01', 615.00, 861.00, 0, 2, 1, 0, '2026-04-03 10:09:43', '2026-04-03 10:09:43', NULL),
(80, 99, 7, 'BBBX25', NULL, '2028-12-12', 480.00, 680.00, 0, 3, 1, 0, '2026-04-03 10:11:31', '2026-04-03 10:11:31', NULL),
(81, 100, 7, 'L3425014', NULL, '2028-07-01', 2250.00, 3150.00, 0, 2, 1, 0, '2026-04-03 10:15:42', '2026-04-03 10:15:42', NULL),
(82, 101, 7, '25VJ53', NULL, '2028-08-12', 200.00, 300.00, 0, 10, 2, 0, '2026-04-03 10:17:38', '2026-04-03 10:17:38', NULL),
(83, 102, 7, '1200', NULL, '2030-12-01', 18000.00, 25200.00, 0, 1, 1, 0, '2026-04-03 10:20:13', '2026-04-03 10:20:13', NULL),
(84, 103, 7, '250206', NULL, '2028-01-01', 1770.00, 2500.00, 0, 2, 1, 0, '2026-04-03 10:27:28', '2026-04-03 10:27:28', NULL),
(85, 104, 7, '01825', NULL, '2028-08-20', 850.00, 1190.00, 0, 2, 1, 0, '2026-04-03 10:31:23', '2026-04-03 10:31:23', NULL),
(86, 105, 7, '35H0129', NULL, '2029-07-01', 570.00, 800.00, 0, 3, 1, 0, '2026-04-03 10:32:35', '2026-04-03 10:32:35', NULL),
(87, 106, 7, '52M0129', NULL, '2029-11-30', 3850.00, 5400.00, 0, 3, 1, 0, '2026-04-03 10:35:47', '2026-04-03 10:35:47', NULL),
(88, 107, 7, '69J0127', NULL, '2027-08-27', 2680.00, 3750.00, 0, 1, 1, 0, '2026-04-03 10:38:00', '2026-04-03 10:38:00', NULL),
(89, 108, 7, '45d0429', NULL, '2029-03-31', 1470.00, 2060.00, 0, 2, 1, 0, '2026-04-03 10:40:19', '2026-04-03 10:40:19', NULL),
(90, 109, 7, 'BBT-37', NULL, '2028-02-01', 980.00, 1400.00, 0, 2, 1, 0, '2026-04-03 10:42:50', '2026-04-03 10:42:50', NULL),
(91, 110, 7, 'BBS01', NULL, '2028-02-01', 480.00, 672.00, 0, 2, 1, 0, '2026-04-03 10:46:57', '2026-04-03 10:46:57', NULL),
(92, 111, 7, '1200', NULL, '2030-01-01', 2800.00, 3950.00, 0, 1, 0, 0, '2026-04-03 10:51:25', '2026-04-03 10:51:25', NULL),
(93, 112, 7, '15T4', NULL, '2028-02-12', 480.00, 675.00, 0, 3, 1, 0, '2026-04-03 11:04:23', '2026-04-03 11:04:23', NULL),
(94, 113, 7, 'CREPE0124', NULL, '2028-02-12', 280.00, 400.00, 0, 12, 2, 0, '2026-04-03 11:08:43', '2026-04-03 11:08:43', NULL),
(95, 114, 7, 'AE15262', NULL, '2027-11-01', 2030.00, 2850.00, 0, 2, 1, 0, '2026-04-03 11:09:41', '2026-04-03 11:09:41', NULL),
(96, 115, 7, '0725', NULL, '2028-05-01', 1365.00, 1920.00, 0, 5, 2, 0, '2026-04-03 11:26:29', '2026-04-03 11:26:29', NULL),
(97, 116, 7, 'S25065', NULL, '2028-09-02', 6500.00, 9100.00, 0, 3, 1, 0, '2026-04-03 11:28:09', '2026-04-03 11:28:09', NULL),
(98, 118, 7, 'E4348', NULL, '2027-11-02', 870.00, 1220.00, 0, 10, 2, 0, '2026-04-03 11:33:04', '2026-04-03 11:33:04', NULL),
(99, 117, 7, '25G07C1', NULL, '2028-07-06', 2366.67, 3320.00, 0, 3, 3, 0, '2026-04-03 11:33:43', '2026-04-03 11:33:43', NULL),
(100, 119, 7, 'T24090', NULL, '2027-11-01', 193.00, 600.00, 0, 10, 2, 0, '2026-04-03 11:38:20', '2026-04-17 12:24:51', NULL),
(101, 120, 7, '202411', NULL, '2029-11-15', 150.00, 250.00, 0, 12, 2, 0, '2026-04-03 11:41:18', '2026-04-03 11:41:18', NULL),
(102, 121, 7, 'CC002F', NULL, '2028-12-02', 287.50, 400.00, 0, 12, 2, 0, '2026-04-03 11:45:16', '2026-04-03 11:45:16', NULL),
(103, 122, 7, '202407', NULL, '2029-07-27', 205.00, 300.00, 0, 12, 2, 0, '2026-04-03 11:45:30', '2026-04-03 11:45:30', NULL),
(104, 123, 7, 'BT044E', NULL, '2028-08-12', 645.00, 900.00, 0, 2, 1, 0, '2026-04-03 11:50:29', '2026-04-03 11:50:29', NULL),
(105, 124, 7, 'L0052', NULL, '2028-06-01', 2230.00, 3150.00, 0, 1, 1, 0, '2026-04-03 11:53:48', '2026-04-03 11:53:48', NULL),
(106, 125, 7, 'OJ709', NULL, '2028-07-01', 175.00, 250.00, 0, 2, 1, 0, '2026-04-03 11:59:18', '2026-04-17 12:54:44', NULL),
(107, 126, 7, '5K256012', NULL, '2028-09-01', 2675.00, 3750.00, 0, 1, 1, 0, '2026-04-03 12:00:18', '2026-04-03 12:00:18', NULL),
(108, 127, 7, '241202', NULL, '2027-12-01', 53.00, 100.00, 0, 10, 2, 0, '2026-04-03 12:05:59', '2026-04-03 12:05:59', NULL),
(109, 128, 7, '37', NULL, '2028-02-01', 3200.00, 4480.00, 0, 1, 0, 0, '2026-04-03 12:06:40', '2026-04-03 12:06:40', NULL),
(110, 129, 7, '23t8', NULL, '2028-10-01', 460.00, 650.00, 0, 2, 1, 0, '2026-04-03 12:11:57', '2026-04-03 12:11:57', NULL),
(111, 130, 7, 'ZAE519', NULL, '2028-04-02', 2100.00, 2950.00, 0, 2, 1, 0, '2026-04-03 12:13:35', '2026-04-03 12:13:35', NULL),
(112, 131, 7, 'AE18520', NULL, '2028-12-01', 1950.00, 2750.00, 0, 5, 2, 0, '2026-04-03 12:16:58', '2026-04-03 12:16:58', NULL),
(113, 132, 7, 'AAE-25320', NULL, '2028-08-12', 513.50, 720.00, 0, 10, 2, 0, '2026-04-03 12:18:15', '2026-04-03 12:18:15', NULL),
(114, 133, 7, '250320', NULL, '2030-03-31', 180.00, 300.00, 0, 10, 2, 0, '2026-04-03 12:21:55', '2026-04-03 12:21:55', NULL),
(115, 134, 7, '2509014B', NULL, '2028-08-20', 3200.00, 4480.00, 0, 2, 2, 0, '2026-04-03 12:22:02', '2026-04-20 12:37:59', NULL),
(116, 135, 7, '435251', NULL, '2027-08-12', 3900.00, 5460.00, 0, 2, 1, 0, '2026-04-03 12:25:44', '2026-04-03 12:25:44', NULL),
(117, 136, 7, '25T26', NULL, '2028-09-30', 420.00, 600.00, 0, 4, 2, 0, '2026-04-03 12:28:15', '2026-04-03 12:28:15', NULL),
(118, 137, 7, 'VBT240052', NULL, '2027-11-11', 3000.00, 4200.00, 0, 3, 1, 0, '2026-04-03 12:29:24', '2026-04-03 12:29:24', NULL),
(119, 138, 7, 'H1255T', NULL, '2028-11-01', 330.00, 500.00, 0, 3, 2, 0, '2026-04-03 12:32:17', '2026-04-03 12:32:17', NULL),
(120, 139, 7, 'GT24486', NULL, '2027-09-02', 1300.00, 1820.00, 0, 2, 1, 0, '2026-04-03 12:37:06', '2026-04-03 12:37:06', NULL),
(121, 140, 7, 'E1T0011', NULL, '2028-08-12', 1600.00, 2240.00, 0, 5, 1, 0, '2026-04-03 12:42:26', '2026-04-03 12:42:26', NULL),
(122, 142, 7, '251019', NULL, '2028-10-31', 95.00, 150.00, 0, 20, 5, 0, '2026-04-03 12:48:53', '2026-04-18 15:29:58', NULL),
(123, 141, 7, 'LSP025002', NULL, '2028-05-12', 875.00, 1250.00, 0, 6, 2, 0, '2026-04-03 12:49:59', '2026-04-03 12:49:59', NULL),
(124, 143, 7, '25363', NULL, '2028-11-30', 720.00, 1050.00, 0, 6, 1, 0, '2026-04-03 12:52:38', '2026-04-18 15:34:07', NULL),
(125, 144, 7, 'CF02046', NULL, '2028-01-31', 2000.00, 2800.00, 0, 5, 2, 0, '2026-04-03 12:53:53', '2026-04-03 12:53:53', NULL),
(126, 145, 7, '29T15', NULL, '2028-09-30', 450.00, 650.00, 0, 5, 2, 0, '2026-04-03 12:56:52', '2026-04-03 12:56:52', NULL),
(127, 146, 7, '5113W', NULL, '2028-09-30', 1180.00, 1700.00, 0, 2, 2, 0, '2026-04-03 13:00:11', '2026-04-18 17:02:02', NULL),
(128, 147, 7, 'CETRO120', NULL, '2028-05-12', 3400.00, 4760.00, 0, 3, 1, 0, '2026-04-03 13:01:42', '2026-04-03 13:01:42', NULL),
(129, 148, 7, 'D125025', NULL, '2028-11-30', 1400.00, 1960.00, 0, 2, 1, 0, '2026-04-03 13:04:26', '2026-04-03 13:04:26', NULL),
(130, 149, 7, '0225022', NULL, '2028-10-31', 1480.00, 2100.00, 0, 2, 1, 0, '2026-04-03 13:09:54', '2026-04-03 13:09:54', NULL),
(131, 150, 7, '25014060-1', NULL, '2027-09-12', 3850.00, 5400.00, 0, 2, 1, 0, '2026-04-03 13:12:43', '2026-04-03 13:12:43', NULL),
(132, 151, 7, 'jei-003', NULL, '2028-03-31', 700.00, 1000.00, 0, 6, 2, 0, '2026-04-03 13:18:18', '2026-04-03 13:18:18', NULL),
(133, 152, 7, '002', NULL, '2028-06-09', 315.41, 450.00, 0, 9, 2, 0, '2026-04-03 13:19:14', '2026-04-20 08:34:59', NULL),
(134, 153, 7, '25GT0108', NULL, '2028-01-12', 2500.00, 3500.00, 0, 3, 1, 0, '2026-04-03 13:24:52', '2026-04-03 13:24:52', NULL),
(135, 154, 7, 'k225122', NULL, '2028-10-31', 4170.00, 5850.00, 0, 1, 1, 0, '2026-04-03 13:25:44', '2026-04-03 13:25:44', NULL),
(136, 155, 7, '32h0230', NULL, '2030-07-31', 1133.33, 1600.00, 0, 9, 3, 0, '2026-04-03 13:32:49', '2026-04-03 13:32:49', NULL),
(137, 156, 7, 'TZL15', NULL, '2027-11-30', 196.00, 300.00, 0, 5, 2, 0, '2026-04-03 13:39:50', '2026-04-03 13:39:50', NULL),
(138, 157, 7, '50118556', NULL, '2029-09-12', 690.00, 1000.00, 0, 5, 1, 0, '2026-04-03 13:41:18', '2026-04-03 13:41:18', NULL),
(139, 158, 7, 'LNUUT-001', NULL, '2028-08-31', 1230.00, 1750.00, 0, 3, 1, 0, '2026-04-03 13:45:13', '2026-04-03 13:45:13', NULL),
(140, 159, 7, 'TESH0034', NULL, '2028-04-12', 1600.00, 2240.00, 0, 1, 0, 0, '2026-04-03 13:45:15', '2026-04-03 13:45:15', NULL),
(141, 160, 7, 'TK958', NULL, '2028-05-20', 2300.00, 3250.00, 0, 2, 1, 0, '2026-04-03 13:51:13', '2026-04-03 13:51:13', NULL),
(142, 161, 7, 'TRO86', NULL, '2028-07-12', 2300.00, 3250.00, 0, 2, 1, 0, '2026-04-03 13:55:46', '2026-04-03 13:55:46', NULL),
(143, 162, 7, 'A250288', NULL, '2028-05-31', 670.00, 950.00, 0, 4, 2, 0, '2026-04-03 13:56:21', '2026-04-18 08:59:56', NULL),
(144, 163, 7, 'D5320321', NULL, '2028-05-31', 17000.00, 23800.00, 0, 1, 1, 0, '2026-04-03 13:59:34', '2026-04-03 13:59:34', NULL),
(145, 164, 7, '741-100', NULL, '2028-02-29', 350.00, 500.00, 0, 5, 2, 0, '2026-04-03 14:04:09', '2026-04-03 14:04:09', NULL),
(146, 165, 7, '17516120312025', NULL, '2030-04-11', 14300.00, 20000.00, 0, 2, 0, 0, '2026-04-03 14:04:49', '2026-04-12 15:02:03', NULL),
(147, 166, 7, '124k', NULL, '2027-02-12', 2890.00, 4050.00, 0, 3, 1, 0, '2026-04-03 14:08:35', '2026-04-03 14:08:35', NULL),
(148, 167, 7, 'BDN250405', NULL, '2030-03-31', 15.50, 50.00, 0, 100, 20, 0, '2026-04-03 14:11:37', '2026-04-03 14:11:37', NULL),
(149, 168, 7, 'WW-AG-25015', NULL, '2030-07-31', 15.50, 50.00, 0, 100, 20, 0, '2026-04-03 14:14:38', '2026-04-03 14:14:38', NULL),
(150, 169, 7, 'N-3342', NULL, '2028-02-29', 800.00, 1150.00, 0, 8, 4, 8, '2026-04-03 14:26:31', '2026-04-06 16:43:41', NULL),
(151, 170, 7, 'TEFH0030', NULL, '2028-06-12', 1600.00, 2250.00, 0, 1, 0, 0, '2026-04-03 14:27:50', '2026-04-03 14:27:50', NULL),
(152, 171, 7, '51094', NULL, '2028-01-31', 8700.00, 12200.00, 0, 1, 1, 0, '2026-04-03 14:29:51', '2026-04-03 14:29:51', NULL),
(153, 172, 7, '1200', NULL, '2030-12-31', 1930.00, 2750.00, 0, 3, 1, 0, '2026-04-03 14:32:20', '2026-04-03 14:32:20', NULL),
(154, 173, 7, '6053', NULL, '2029-06-12', 2545.00, 3600.00, 0, 2, 1, 0, '2026-04-03 14:35:07', '2026-04-03 14:35:07', NULL),
(155, 174, 7, '4RL2C', NULL, '2027-10-31', 18000.00, 25200.00, 0, 1, 1, 0, '2026-04-03 14:36:03', '2026-04-03 14:36:03', NULL),
(156, 175, 7, 'AHK084', NULL, '2027-08-31', 10765.00, 15100.00, 0, 2, 1, 0, '2026-04-03 14:39:10', '2026-04-03 14:39:10', NULL),
(157, 176, 7, 'T66208', NULL, '2028-01-31', 335.00, 470.00, 0, 10, 2, 0, '2026-04-03 14:39:35', '2026-04-03 14:39:35', NULL),
(158, 177, 7, '25CQ025', NULL, '2028-02-29', 3700.00, 5200.00, 0, 3, 0, 0, '2026-04-03 14:42:43', '2026-04-18 16:56:33', NULL),
(159, 178, 7, 'DD125006', NULL, '2028-10-31', 1650.00, 2350.00, 0, 3, 1, 0, '2026-04-03 14:43:05', '2026-04-03 14:43:05', NULL),
(160, 179, 7, 'L0125088', NULL, '2028-08-31', 1660.00, 2350.00, 0, 3, 2, 0, '2026-04-03 14:45:47', '2026-04-03 14:45:47', NULL),
(161, 180, 7, '17356', NULL, '2027-09-12', 800.00, 1150.00, 0, 6, 1, 0, '2026-04-03 14:47:00', '2026-04-03 14:47:00', NULL),
(162, 181, 7, 'R111179Q', NULL, '2028-10-31', 1730.00, 2450.00, 0, 3, 2, 0, '2026-04-03 14:48:23', '2026-04-03 14:48:23', NULL),
(163, 182, 7, '0725103', NULL, '2028-07-31', 12800.00, 17920.00, 0, 2, 1, 0, '2026-04-03 14:51:23', '2026-04-03 14:51:23', NULL),
(164, 183, 7, '040', NULL, '2027-01-12', 1150.00, 1610.00, 0, 3, 1, 0, '2026-04-03 14:51:42', '2026-04-03 14:51:42', NULL),
(165, 184, 7, 'L569E', NULL, '2028-11-30', 750.00, 1050.00, 0, 9, 2, 0, '2026-04-03 14:54:47', '2026-04-18 09:03:10', NULL),
(166, 185, 7, 'CF250500', NULL, '2028-04-12', 490.00, 700.00, 0, 3, 1, 0, '2026-04-03 14:56:01', '2026-04-03 14:56:01', NULL),
(167, 186, 7, 'AE19119', NULL, '2028-12-12', 965.00, 1351.00, 0, 2, 1, 0, '2026-04-03 15:03:13', '2026-04-03 15:03:13', NULL),
(168, 187, 7, '6003X', NULL, '2027-12-31', 1700.00, 2400.00, 0, 2, 1, 0, '2026-04-03 15:05:29', '2026-04-03 15:05:29', NULL),
(169, 188, 7, '10241993', NULL, '2028-07-12', 1875.00, 2625.00, 0, 2, 1, 0, '2026-04-03 15:07:00', '2026-04-03 15:07:00', NULL),
(170, 189, 7, 'T2525012', NULL, '2028-08-31', 850.00, 1200.00, 0, 5, 2, 0, '2026-04-03 15:08:12', '2026-04-03 15:08:12', NULL),
(171, 190, 7, 'R32506', NULL, '2028-07-12', 930.00, 1300.00, 0, 2, 1, 0, '2026-04-03 15:10:10', '2026-04-03 15:10:10', NULL),
(172, 191, 7, 'N-3502', NULL, '2028-09-12', 1820.00, 2550.00, 0, 2, 1, 0, '2026-04-03 15:13:28', '2026-04-03 15:13:28', NULL),
(173, 192, 7, 'T3225005', NULL, '2028-10-31', 70.00, 100.00, 0, 10, 10, 0, '2026-04-03 15:15:39', '2026-04-03 15:15:39', NULL),
(174, 193, 7, 'TB3-20', NULL, '2028-09-12', 780.00, 1100.00, 0, 3, 1, 0, '2026-04-03 15:16:44', '2026-04-03 15:16:44', NULL),
(175, 195, 7, 'DFG4302A', NULL, '2028-05-12', 2050.00, 2870.00, 0, 2, 1, 0, '2026-04-03 15:20:22', '2026-04-03 15:20:22', NULL),
(176, 194, 7, 'Q2504002', NULL, '2028-03-31', 191.00, 300.00, 0, 10, 10, 0, '2026-04-03 15:20:28', '2026-04-03 15:20:28', NULL),
(177, 196, 7, 'R12587', NULL, '2028-11-12', 1690.00, 2400.00, 0, 2, 1, 0, '2026-04-03 15:24:24', '2026-04-03 15:24:24', NULL),
(178, 197, 7, '40T52', NULL, '2028-08-31', 1200.00, 1700.00, 0, 5, 2, 0, '2026-04-03 15:25:05', '2026-04-03 15:25:05', NULL),
(179, 198, 7, 'ONR004', NULL, '2028-06-12', 1600.00, 2250.00, 0, 2, 1, 0, '2026-04-03 15:29:05', '2026-04-03 15:29:05', NULL),
(180, 200, 7, 'RN492', NULL, '2028-06-28', 750.00, 1050.00, 0, 2, 1, 0, '2026-04-03 15:34:04', '2026-04-03 15:34:04', NULL),
(181, 199, 7, '10T43', NULL, '2028-10-31', 960.00, 1350.00, 0, 2, 1, 0, '2026-04-03 15:34:28', '2026-04-03 15:34:28', NULL),
(182, 201, 7, 'AE17579', NULL, '2028-12-12', 695.00, 980.00, 0, 2, 1, 0, '2026-04-03 15:37:36', '2026-04-03 15:37:36', NULL),
(183, 202, 7, '129L0127', NULL, '2027-10-31', 750.00, 1050.00, 0, 2, 1, 0, '2026-04-03 15:38:13', '2026-04-03 15:38:13', NULL),
(184, 203, 7, '50318010B', NULL, '2029-10-12', 1150.00, 1610.00, 0, 5, 1, 0, '2026-04-03 15:41:54', '2026-04-03 15:41:54', NULL),
(185, 204, 7, '0001/2', NULL, '2028-07-31', 76.43, 150.00, 0, 7, 7, 0, '2026-04-03 15:43:35', '2026-04-03 15:43:35', NULL),
(186, 206, 7, 'E414', NULL, '2028-11-12', 2465.00, 3450.00, 0, 5, 1, 0, '2026-04-03 15:47:10', '2026-04-03 15:47:10', NULL),
(187, 205, 7, 'E411', NULL, '2027-10-31', 3210.00, 4500.00, 0, 4, 2, 0, '2026-04-03 15:48:05', '2026-04-03 15:48:05', NULL),
(188, 207, 7, 'SM250639', NULL, '2028-05-12', 209.00, 300.00, 0, 19, 5, 0, '2026-04-03 15:51:25', '2026-04-20 08:17:52', NULL),
(189, 208, 7, '250126', NULL, '2028-01-24', 3800.00, 5400.00, 0, 3, 2, 0, '2026-04-03 15:52:29', '2026-04-03 15:52:29', NULL),
(190, 209, 7, '010', NULL, '2030-12-12', 2200.00, 3080.00, 0, 1, 0, 0, '2026-04-03 15:53:49', '2026-04-03 15:53:49', NULL),
(191, 211, 7, 'CF03527', NULL, '2028-02-20', 735.00, 1050.00, 0, 10, 5, 0, '2026-04-03 15:57:25', '2026-04-03 15:57:25', NULL),
(192, 210, 7, 'ASL25161', NULL, '2027-07-31', 3800.00, 5350.00, 0, 2, 2, 0, '2026-04-03 15:59:05', '2026-04-03 15:59:05', NULL),
(193, 212, 7, 'FE', NULL, '2028-08-12', 200.00, 280.00, 0, 10, 2, 0, '2026-04-03 16:01:00', '2026-04-03 16:01:00', NULL),
(194, 213, 7, 'ARL25070', NULL, '2027-08-31', 3800.00, 5350.00, 0, 2, 2, 0, '2026-04-03 16:04:31', '2026-04-03 16:04:31', NULL),
(195, 214, 7, 'T25005', NULL, '2027-12-12', 285.00, 400.00, 0, 4, 1, 0, '2026-04-03 16:04:49', '2026-04-03 16:04:49', NULL),
(196, 215, 7, 'Wosa121', NULL, '2027-09-12', 1745.00, 2450.00, 0, 1, 0, 0, '2026-04-03 16:08:34', '2026-04-03 16:08:34', NULL),
(197, 216, 7, 'SC1-09', NULL, '2028-08-31', 590.00, 850.00, 0, 5, 2, 0, '2026-04-03 16:08:44', '2026-04-03 16:08:44', NULL),
(198, 217, 7, 'CD3-02', NULL, '2028-07-31', 3300.00, 4650.00, 0, 3, 1, 0, '2026-04-03 16:12:12', '2026-04-03 16:12:12', NULL),
(199, 218, 7, '240633', NULL, '2027-06-12', 75.00, 105.00, 0, 10, 2, 0, '2026-04-03 16:12:30', '2026-04-03 16:12:30', NULL),
(200, 219, 7, 'TB1-48', NULL, '2028-08-31', 3100.00, 4350.00, 0, 3, 1, 0, '2026-04-03 16:15:47', '2026-04-03 16:15:47', NULL),
(201, 220, 7, 'T2225001', NULL, '2027-12-12', 246.00, 350.00, 0, 10, 2, 0, '2026-04-03 16:16:09', '2026-04-03 16:16:09', NULL),
(202, 221, 7, 'CDM5-36', NULL, '2027-07-31', 2785.00, 3900.00, 0, 1, 1, 0, '2026-04-03 16:23:10', '2026-04-03 16:23:10', NULL),
(203, 222, 7, 'VA-3241', NULL, '2028-09-12', 1600.00, 2250.00, 0, 1, 0, 0, '2026-04-03 16:23:41', '2026-04-03 16:23:41', NULL),
(204, 223, 7, '54424011A', NULL, '2027-11-12', 1200.00, 1680.00, 0, 6, 2, 0, '2026-04-03 16:27:03', '2026-04-03 16:27:03', NULL),
(205, 224, 7, '062A2535X', NULL, '2028-08-23', 290.00, 425.00, 0, 11, 5, 0, '2026-04-03 16:28:01', '2026-04-18 11:38:26', NULL),
(206, 225, 7, 'B41402', NULL, '2029-07-12', 1200.00, 1680.00, 0, 3, 1, 0, '2026-04-03 16:32:11', '2026-04-18 18:55:22', NULL),
(207, 226, 7, '456F46', NULL, '2028-08-28', 1850.00, 2590.00, 0, 5, 1, 0, '2026-04-03 16:36:38', '2026-04-03 16:36:38', NULL),
(208, 227, 7, '266021', NULL, '2027-08-12', 2900.00, 4060.00, 0, 5, 1, 0, '2026-04-03 16:39:31', '2026-04-03 16:39:31', NULL),
(209, 228, 7, '20231118', NULL, '2028-11-17', 433.33, 650.00, 0, 12, 2, 0, '2026-04-04 11:48:40', '2026-04-04 11:48:40', NULL),
(211, 229, 7, '2502018A', NULL, '2028-01-31', 4300.00, 6050.00, 0, 5, 2, 0, '2026-04-04 11:58:32', '2026-04-04 11:58:32', NULL),
(212, 230, 7, '25HB20', NULL, '2028-03-12', 320.00, 450.00, 0, 10, 2, 0, '2026-04-04 12:05:40', '2026-04-04 12:05:40', NULL),
(213, 231, 7, 'CM135', NULL, '2028-10-12', 630.00, 882.00, 0, 5, 2, 0, '2026-04-04 12:13:40', '2026-04-04 12:13:40', NULL),
(214, 232, 7, '25374', NULL, '2027-11-30', 670.00, 950.00, 0, 3, 2, 0, '2026-04-04 12:16:38', '2026-04-04 12:16:38', NULL),
(215, 233, 7, 'T2625142', NULL, '2028-07-12', 140.00, 200.00, 0, 20, 5, 0, '2026-04-04 12:18:08', '2026-04-04 12:18:08', NULL),
(216, 234, 7, '320F01', NULL, '2028-03-31', 4770.00, 6700.00, 0, 2, 1, 0, '2026-04-04 12:21:16', '2026-04-04 12:21:16', NULL),
(217, 235, 7, '3325', NULL, '2030-12-12', 140.00, 200.00, 0, 20, 5, 0, '2026-04-04 12:24:01', '2026-04-04 12:24:01', NULL),
(218, 236, 7, '366f02', NULL, '2028-06-30', 7900.00, 11100.00, 0, 2, 1, 0, '2026-04-04 12:24:51', '2026-04-04 12:24:51', NULL),
(219, 237, 7, 'MOA440', NULL, '2027-09-12', 428.00, 600.00, 0, 10, 5, 0, '2026-04-04 12:30:31', '2026-04-04 12:30:31', NULL),
(220, 238, 7, 'C045168', NULL, '2027-10-31', 430.00, 650.00, 0, 10, 4, 0, '2026-04-04 12:35:16', '2026-04-04 12:35:16', NULL),
(221, 239, 7, '22J0129', NULL, '2029-08-12', 1640.00, 2300.00, 0, 1, 0, 0, '2026-04-04 12:36:01', '2026-04-04 12:36:01', NULL),
(222, 240, 7, 'FPL150225', NULL, '2028-10-31', 590.00, 850.00, 0, 2, 2, 0, '2026-04-04 12:39:45', '2026-04-04 12:39:45', NULL),
(223, 241, 7, 'K230214NY', NULL, '2028-02-12', 208.33, 300.00, 0, 12, 5, 0, '2026-04-04 12:44:56', '2026-04-04 12:44:56', NULL),
(224, 242, 7, '20250326', NULL, '2030-03-25', 480.00, 700.00, 0, 8, 2, 0, '2026-04-04 12:47:01', '2026-04-18 14:49:55', NULL),
(225, 243, 7, 'ONOH0185', NULL, '2028-04-12', 2800.00, 3920.00, 0, 3, 1, 0, '2026-04-04 12:49:35', '2026-04-04 12:49:35', NULL),
(226, 244, 7, 'ADS1925', NULL, '2027-09-30', 935.00, 1350.00, 0, 1, 1, 0, '2026-04-04 12:52:45', '2026-04-04 12:52:45', NULL),
(227, 245, 7, 'E507', NULL, '2029-06-12', 2465.00, 3450.00, 0, 2, 1, 0, '2026-04-04 12:53:51', '2026-04-04 12:53:51', NULL),
(228, 246, 7, 'F451125', NULL, '2028-10-31', 428.00, 600.00, 0, 8, 2, 0, '2026-04-04 12:59:00', '2026-04-12 09:05:11', NULL),
(229, 247, 7, 'D51025', NULL, '2028-09-30', 1050.00, 1500.00, 0, 3, 1, 0, '2026-04-04 13:01:52', '2026-04-04 13:01:52', NULL),
(230, 248, 7, 'T021025', NULL, '2028-09-30', 655.00, 950.00, 0, 2, 1, 0, '2026-04-04 13:06:34', '2026-04-04 13:06:34', NULL),
(231, 249, 7, 'YBT240053', NULL, '2027-11-12', 5240.00, 7400.00, 0, 3, 1, 0, '2026-04-04 13:07:58', '2026-04-04 13:07:58', NULL),
(232, 250, 7, 'MP24505', NULL, '2027-09-30', 1070.00, 1500.00, 0, 2, 2, 0, '2026-04-04 13:11:47', '2026-04-04 13:11:47', NULL),
(233, 251, 7, '5B516011', NULL, '2028-01-01', 79.20, 120.00, 0, 25, 5, 0, '2026-04-04 13:15:14', '2026-04-17 12:56:43', NULL),
(234, 252, 7, 'MP24506', NULL, '2027-09-30', 1300.00, 1850.00, 0, 2, 2, 0, '2026-04-04 13:15:21', '2026-04-04 13:15:21', NULL),
(235, 253, 7, '2725', NULL, '2030-07-12', 575.00, 805.00, 0, 5, 1, 0, '2026-04-04 13:18:43', '2026-04-04 13:18:43', NULL),
(236, 254, 7, 'ML111', NULL, '2029-01-31', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-04 13:19:17', '2026-04-04 13:19:17', NULL),
(237, 255, 7, 'BGN251106', NULL, '2030-10-12', 15.00, 21.00, 0, 100, 20, 0, '2026-04-04 13:22:33', '2026-04-04 13:22:33', NULL),
(238, 256, 7, 'HAS251109', NULL, '2030-11-30', 35.65, 50.00, 0, 100, 20, 0, '2026-04-04 13:23:59', '2026-04-04 13:23:59', NULL),
(239, 257, 7, '250193', NULL, '2027-12-12', 42.00, 60.00, 0, 10, 2, 0, '2026-04-04 13:27:11', '2026-04-04 13:27:11', NULL),
(240, 258, 7, 'EBS251205', NULL, '2030-12-31', 36.50, 50.00, 0, 200, 50, 0, '2026-04-04 13:28:54', '2026-04-04 13:28:54', NULL),
(241, 259, 7, '250313', NULL, '2028-02-12', 50.00, 70.00, 0, 10, 2, 0, '2026-04-04 13:34:38', '2026-04-04 13:34:38', NULL),
(242, 260, 7, '241080', NULL, '2027-09-12', 40.00, 56.00, 0, 10, 2, 0, '2026-04-04 13:38:56', '2026-04-04 13:38:56', NULL),
(243, 262, 7, '2451kl', NULL, '2028-02-12', 1070.00, 1500.00, 0, 2, 1, 0, '2026-04-04 13:41:33', '2026-04-04 13:41:33', NULL),
(244, 263, 7, '55cm', NULL, '2028-12-01', 1100.00, 1540.00, 0, 2, 1, 0, '2026-04-04 13:44:09', '2026-04-04 13:44:09', NULL),
(245, 264, 7, 'PP45', NULL, '2028-12-12', 585.00, 819.00, 0, 2, 1, 0, '2026-04-04 13:46:21', '2026-04-04 13:46:21', NULL),
(246, 261, 7, '5A158005', NULL, '2027-12-31', 98.60, 150.00, 0, 21, 5, 0, '2026-04-04 13:47:49', '2026-04-18 15:45:41', NULL),
(247, 265, 7, 'VBD250050', NULL, '2028-03-03', 3300.00, 4620.00, 0, 2, 1, 0, '2026-04-04 13:50:07', '2026-04-04 13:50:07', NULL),
(248, 266, 7, 'VBD250026', NULL, '2028-01-12', 3300.00, 4620.00, 0, 2, 1, 0, '2026-04-04 13:52:44', '2026-04-04 13:52:44', NULL),
(249, 267, 7, 'A047', NULL, '2028-01-31', 650.00, 910.00, 0, 5, 2, 0, '2026-04-04 13:56:13', '2026-04-04 13:56:13', NULL),
(250, 268, 7, 'NOA7006', NULL, '2028-01-12', 2550.00, 3570.00, 0, 2, 1, 0, '2026-04-04 13:58:00', '2026-04-04 13:58:00', NULL),
(251, 269, 7, 'ADL1825', NULL, '2027-07-12', 845.00, 1200.00, 0, 3, 1, 0, '2026-04-04 14:01:56', '2026-04-04 14:01:56', NULL),
(252, 270, 7, '25102', NULL, '2028-04-12', 720.00, 1000.00, 0, 2, 1, 0, '2026-04-04 14:05:03', '2026-04-04 14:05:03', NULL),
(253, 271, 7, '1200', NULL, '2030-12-31', 350.00, 500.00, 0, 5, 2, 0, '2026-04-04 14:07:57', '2026-04-04 14:07:57', NULL),
(254, 272, 7, '421L5104', NULL, '2028-10-12', 700.00, 980.00, 0, 3, 1, 0, '2026-04-04 14:12:19', '2026-04-04 14:12:19', NULL),
(255, 273, 7, 'DCLEI4015', NULL, '2027-08-31', 42.00, 100.00, 0, 20, 5, 0, '2026-04-04 14:15:06', '2026-04-04 14:15:06', NULL),
(256, 274, 7, '36T88', NULL, '2028-10-12', 690.00, 970.00, 0, 3, 1, 0, '2026-04-04 14:16:11', '2026-04-04 14:16:11', NULL),
(257, 275, 7, 'MP2512', NULL, '2028-11-12', 500.00, 700.00, 0, 2, 1, 0, '2026-04-04 14:19:21', '2026-04-04 14:19:21', NULL),
(258, 276, 7, 'EMD25028', NULL, '2028-01-30', 4550.00, 6400.00, 0, 5, 2, 0, '2026-04-04 14:20:55', '2026-04-18 14:55:58', NULL),
(259, 277, 7, 'FH342', NULL, '2028-07-12', 6900.00, 9660.00, 0, 2, 1, 0, '2026-04-04 14:23:29', '2026-04-04 14:23:29', NULL),
(260, 278, 7, '202407', NULL, '2029-07-01', 13.38, 20.00, 0, 80, 80, 0, '2026-04-04 14:26:32', '2026-04-04 14:26:32', NULL),
(261, 279, 7, '3462E', NULL, '2028-12-31', 3.93, 10.00, 0, 1000, 200, 0, '2026-04-04 14:33:01', '2026-04-04 14:33:01', NULL),
(262, 280, 7, 'BN5E434004', NULL, '2027-04-12', 845.00, 1200.00, 0, 3, 1, 0, '2026-04-04 14:35:11', '2026-04-04 14:35:11', NULL),
(263, 281, 7, '1200', NULL, '2030-05-29', 1600.00, 2250.00, 0, 2, 2, 0, '2026-04-04 14:38:50', '2026-04-04 14:38:50', NULL),
(264, 283, 7, '8312', NULL, '2028-03-31', 113.50, 160.00, 0, 20, 10, 0, '2026-04-04 14:49:02', '2026-04-04 14:49:02', NULL),
(265, 282, 7, 'A250529', NULL, '2027-11-12', 600.00, 850.00, 0, 5, 1, 0, '2026-04-04 14:50:39', '2026-04-04 14:50:39', NULL),
(266, 284, 7, 'L520E', NULL, '2028-10-31', 620.00, 900.00, 0, 5, 2, 0, '2026-04-04 14:52:41', '2026-04-04 14:52:41', NULL),
(267, 285, 7, '658240902', NULL, '2027-09-20', 1820.00, 2550.00, 0, 6, 1, 0, '2026-04-04 14:55:16', '2026-04-04 14:55:16', NULL),
(268, 286, 7, 'L376E', NULL, '2028-07-31', 650.00, 910.00, 0, 3, 1, 0, '2026-04-04 14:56:05', '2026-04-04 14:56:05', NULL),
(269, 287, 7, 'L420E', NULL, '2028-08-31', 750.00, 1050.00, 0, 5, 2, 0, '2026-04-04 14:59:39', '2026-04-04 14:59:39', NULL),
(270, 288, 7, '24600', NULL, '2027-10-31', 1765.00, 2500.00, 0, 2, 1, 0, '2026-04-04 15:03:32', '2026-04-04 15:03:32', NULL),
(271, 289, 7, 'Q26001N', NULL, '2028-01-31', 550.00, 800.00, 0, 3, 1, 0, '2026-04-04 15:06:51', '2026-04-04 15:06:51', NULL),
(272, 290, 7, 'EML25109', NULL, '2029-11-30', 4280.00, 6000.00, 0, 1, 1, 0, '2026-04-04 15:09:46', '2026-04-04 15:09:46', NULL),
(273, 291, 7, '042225', NULL, '2030-03-31', 246.10, 350.00, 0, 50, 10, 0, '2026-04-04 15:13:52', '2026-04-04 15:13:52', NULL),
(274, 292, 7, '4218', NULL, '2028-12-12', 1700.00, 2210.00, 0, 3, 1, 0, '2026-04-06 11:29:00', '2026-04-06 11:29:00', NULL),
(275, 294, 7, '124lk', NULL, '2028-12-12', 1666.66, 2200.00, 0, 3, 1, 0, '2026-04-06 11:31:48', '2026-04-06 11:31:48', NULL),
(276, 293, 7, '1200', NULL, '2026-07-31', 625.00, 812.50, 0, 11, 2, 0, '2026-04-06 11:32:19', '2026-04-18 08:59:56', NULL),
(277, 294, 7, '1424', NULL, '2028-12-12', 1666.66, 2199.99, 0, 3, 1, 0, '2026-04-06 11:34:09', '2026-04-06 11:34:09', NULL),
(278, 295, 7, '1200', NULL, '2027-03-23', 320.83, 417.08, 0, 24, 5, 0, '2026-04-06 11:36:31', '2026-04-06 11:52:11', NULL),
(279, 296, 7, '1200', NULL, '2026-12-31', 408.30, 530.79, 0, 24, 5, 0, '2026-04-06 11:39:53', '2026-04-06 11:51:08', NULL),
(280, 297, 7, '254521', NULL, '2027-11-12', 1800.00, 2350.00, 0, 5, 1, 0, '2026-04-06 11:41:57', '2026-04-06 11:41:57', NULL),
(281, 298, 7, '1200', NULL, '2026-10-31', 291.67, 380.00, 0, 24, 5, 0, '2026-04-06 11:42:31', '2026-04-06 11:51:33', NULL),
(282, 300, 7, '260441', NULL, '2027-07-12', 1250.00, 1650.00, 0, 5, 1, 0, '2026-04-06 11:47:04', '2026-04-06 11:47:04', NULL),
(283, 299, 7, '1200', NULL, '2027-01-23', 366.67, 480.00, 0, 24, 5, 0, '2026-04-06 11:49:12', '2026-04-06 11:49:12', NULL),
(284, 301, 7, '9B', NULL, '2028-08-11', 156.25, 203.13, 0, 144, 10, 0, '2026-04-06 11:55:40', '2026-04-06 11:55:40', NULL),
(285, 303, 7, '31', NULL, '2026-12-31', 395.83, 520.00, 0, 12, 2, 0, '2026-04-06 11:58:52', '2026-04-06 11:58:52', NULL),
(286, 302, 7, '1245E', NULL, '2028-12-12', 4500.00, 5850.00, 0, 1, 0, 0, '2026-04-06 11:59:22', '2026-04-06 11:59:22', NULL),
(287, 305, 7, '45417', NULL, '2028-12-12', 4500.00, 5850.00, 0, 1, 1, 0, '2026-04-06 12:01:21', '2026-04-06 12:01:21', NULL),
(288, 304, 7, '31M2', NULL, '2026-12-31', 395.83, 520.00, 0, 12, 2, 0, '2026-04-06 12:01:33', '2026-04-06 12:01:33', NULL),
(289, 306, 7, '6294015161960', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 0, 0, '2026-04-06 12:03:52', '2026-04-06 12:03:52', NULL),
(290, 307, 7, '4892573027531', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 0, 0, '2026-04-06 12:07:16', '2026-04-06 12:07:16', NULL),
(291, 308, 7, '6294015161915', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 0, 0, '2026-04-06 12:08:53', '2026-04-06 12:08:53', NULL),
(292, 309, 7, '4892573027517', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 0, 0, '2026-04-06 12:10:21', '2026-04-06 12:10:21', NULL),
(293, 310, 7, '6294015161991', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 0, 0, '2026-04-06 12:12:09', '2026-04-06 12:12:09', NULL),
(294, 311, 7, '6294015161953', NULL, '2028-12-12', 1750.00, 2300.00, 0, 1, 1, 0, '2026-04-06 12:13:31', '2026-04-06 12:13:31', NULL),
(295, 312, 7, '05114JB17', NULL, '2028-12-12', 8500.00, 11050.00, 0, 2, 1, 0, '2026-04-06 12:15:56', '2026-04-06 12:15:56', NULL),
(296, 313, 7, '5064017A', NULL, '2030-10-31', 1177.00, 1647.80, 0, 1, 1, 0, '2026-04-06 12:18:28', '2026-04-06 12:18:28', NULL),
(297, 314, 7, 'A2-1655', NULL, '2028-09-12', 1666.66, 2200.00, 1, 3, 1, 0, '2026-04-06 12:19:57', '2026-04-18 16:54:59', NULL),
(298, 316, 7, '8935212811026', NULL, '2028-12-12', 1666.66, 2200.00, 1, 4, 1, 0, '2026-04-06 12:22:39', '2026-04-06 12:22:39', NULL),
(299, 315, 7, '0716154', NULL, '2029-07-31', 330.50, 500.00, 0, 20, 4, 1, '2026-04-06 12:23:25', '2026-04-17 12:36:23', NULL),
(300, 317, 7, '8935212811842', NULL, '2028-12-12', 1666.66, 2200.00, 1, 2, 2, 0, '2026-04-06 12:25:05', '2026-04-06 12:25:05', NULL),
(301, 318, 7, '8935212810845', NULL, '2028-12-12', 1666.66, 2200.00, 1, 1, 1, 0, '2026-04-06 12:26:19', '2026-04-15 14:58:19', NULL),
(302, 319, 7, 'CF03513', NULL, '2028-02-29', 1233.10, 1730.00, 0, 10, 2, 0, '2026-04-06 12:27:37', '2026-04-06 12:27:37', NULL),
(303, 320, 7, '6156000101033', NULL, '2028-12-12', 3500.00, 4550.00, 1, 3, 1, 0, '2026-04-06 12:27:49', '2026-04-06 12:27:49', NULL),
(304, 321, 7, '6156000101040', NULL, '2028-12-12', 3500.00, 4550.00, 1, 3, 1, 0, '2026-04-06 12:29:00', '2026-04-06 12:29:00', NULL),
(305, 322, 7, '8699009466768', NULL, '2028-12-12', 2500.00, 3250.00, 1, 2, 1, 0, '2026-04-06 12:32:37', '2026-04-06 12:32:37', NULL),
(306, 323, 7, '8699009466720', NULL, '2028-12-12', 2500.00, 3250.00, 1, 2, 1, 0, '2026-04-06 12:34:24', '2026-04-06 12:34:24', NULL),
(307, 324, 7, '379166', NULL, '2030-08-31', 9650.00, 13510.00, 0, 1, 1, 0, '2026-04-06 12:35:02', '2026-04-06 12:35:02', NULL),
(308, 325, 7, '8699009464917', NULL, '2028-12-12', 2500.00, 3250.00, 1, 1, 0, 0, '2026-04-06 12:35:32', '2026-04-06 12:35:32', NULL),
(309, 326, 7, '8699009466713', NULL, '2028-12-12', 2500.00, 3250.00, 1, 1, 0, 0, '2026-04-06 12:36:29', '2026-04-06 12:36:29', NULL),
(310, 327, 7, '6154000086114', NULL, '2028-12-12', 1500.00, 1950.00, 1, 4, 1, 0, '2026-04-06 12:39:06', '2026-04-06 12:39:06', NULL),
(311, 328, 7, '6154000086206', NULL, '2028-12-12', 1500.00, 1950.00, 1, 2, 1, 0, '2026-04-06 12:40:46', '2026-04-06 12:40:46', NULL),
(312, 329, 7, '25GC0094', NULL, '2028-07-31', 927.33, 1300.00, 0, 4, 4, 0, '2026-04-06 12:42:01', '2026-04-06 12:42:01', NULL),
(313, 330, 7, '6154000403447', NULL, '2028-12-12', 1250.00, 1650.00, 1, 2, 1, 0, '2026-04-06 12:42:36', '2026-04-06 12:42:36', NULL),
(314, 331, 7, '714084866390', NULL, '2028-12-12', 1250.00, 1650.00, 1, 2, 1, 0, '2026-04-06 12:43:57', '2026-04-06 12:43:57', NULL),
(315, 332, 7, '6156000060538', NULL, '2028-12-12', 2500.00, 3250.00, 1, 2, 1, 0, '2026-04-06 12:45:41', '2026-04-06 12:45:41', NULL),
(316, 333, 7, 'A250422', NULL, '2028-08-31', 246.00, 350.00, 0, 6, 6, 0, '2026-04-06 12:52:01', '2026-04-06 12:52:01', NULL),
(317, 334, 7, '2424311', NULL, '2027-12-31', 2629.00, 3700.00, 0, 2, 2, 0, '2026-04-06 13:00:11', '2026-04-06 13:00:11', NULL),
(318, 335, 7, '10606', NULL, '2028-05-31', 909.50, 1300.00, 0, 4, 4, 0, '2026-04-06 13:04:44', '2026-04-06 13:04:44', NULL),
(319, 336, 7, '10008', NULL, '2027-09-30', 732.50, 1050.00, 0, 2, 2, 0, '2026-04-06 13:08:05', '2026-04-06 13:08:05', NULL),
(320, 119, 7, 'T25052', NULL, '2028-09-01', 413.20, 600.00, 0, 5, 5, 0, '2026-04-06 13:14:41', '2026-04-17 12:24:51', NULL),
(321, 337, 7, 'FD2502C', NULL, '2028-05-31', 1712.00, 2400.00, 0, 3, 3, 0, '2026-04-06 13:24:39', '2026-04-06 13:24:39', NULL),
(322, 338, 7, '4980', NULL, '2030-04-30', 3745.00, 5250.00, 0, 1, 1, 0, '2026-04-06 13:28:43', '2026-04-06 13:28:43', NULL),
(323, 339, 7, 'BD029', NULL, '2027-12-12', 650.00, 850.00, 0, 4, 1, 0, '2026-04-06 13:34:44', '2026-04-06 13:34:44', NULL),
(324, 340, 7, 'T25076', NULL, '2028-11-30', 2639.33, 3700.00, 0, 3, 3, 0, '2026-04-06 13:36:51', '2026-04-06 13:36:51', NULL),
(325, 341, 7, 'BE425001', NULL, '2028-01-12', 510.00, 720.00, 0, 10, 5, 0, '2026-04-06 13:38:29', '2026-04-06 13:38:29', NULL),
(326, 342, 7, '0074', NULL, '2028-08-31', 236.50, 350.00, 0, 10, 5, 0, '2026-04-06 13:39:46', '2026-04-06 13:39:46', NULL),
(327, 343, 7, 'E1573', NULL, '2027-10-12', 3900.00, 5460.00, 0, 2, 1, 0, '2026-04-06 13:41:40', '2026-04-06 13:41:40', NULL),
(328, 344, 7, 'PX-2513', NULL, '2028-05-31', 577.80, 810.00, 0, 5, 2, 0, '2026-04-06 13:43:19', '2026-04-06 13:43:19', NULL),
(329, 345, 7, 'L0625027', NULL, '2027-02-02', 770.00, 1080.00, 0, 3, 1, 0, '2026-04-06 13:47:24', '2026-04-06 13:47:24', NULL),
(330, 346, 7, '25I0352', NULL, '2027-09-30', 2200.00, 3100.00, 0, 1, 1, 0, '2026-04-06 13:49:53', '2026-04-06 13:49:53', NULL),
(331, 347, 7, '16033525', NULL, '2028-01-12', 1070.00, 1500.00, 0, 4, 1, 0, '2026-04-06 13:51:36', '2026-04-06 13:51:36', NULL),
(332, 348, 7, 'SE25D4', NULL, '2028-05-31', 5029.00, 7050.00, 0, 1, 1, 0, '2026-04-06 13:53:00', '2026-04-06 13:53:00', NULL),
(333, 349, 7, '6089', NULL, '2030-05-12', 5030.00, 7050.00, 0, 3, 1, 0, '2026-04-06 13:56:13', '2026-04-06 13:56:13', NULL),
(334, 350, 7, 'GT25030', NULL, '2027-12-04', 495.00, 1800.00, 0, 3, 3, 3, '2026-04-06 13:57:51', '2026-04-06 14:10:45', NULL),
(335, 351, 7, '187', NULL, '2028-11-12', 365.00, 500.00, 0, 24, 2, 0, '2026-04-06 14:12:26', '2026-04-06 14:12:26', NULL),
(336, 352, 7, 'GT25030', NULL, '2027-12-31', 495.00, 700.00, 0, 6, 3, 0, '2026-04-06 14:16:05', '2026-04-06 14:16:05', NULL),
(337, 353, 7, 'L0925015', NULL, '2027-06-12', 770.00, 1080.00, 0, 3, 0, 0, '2026-04-06 14:17:24', '2026-04-06 14:17:24', NULL),
(338, 354, 7, 'ASMY0023', NULL, '2028-07-31', 1063.00, 1500.00, 0, 3, 3, 0, '2026-04-06 14:19:41', '2026-04-06 14:19:41', NULL),
(339, 355, 7, 'L0725006', NULL, '2027-03-12', 770.00, 1080.00, 0, 3, 1, 0, '2026-04-06 14:22:26', '2026-04-06 14:22:26', NULL),
(340, 356, 7, 'R060669T', NULL, '2028-07-12', 1840.00, 2600.00, 0, 5, 2, 0, '2026-04-06 14:26:18', '2026-04-06 14:26:18', NULL),
(341, 357, 7, '25013', NULL, '2028-04-30', 642.00, 900.00, 0, 20, 5, 0, '2026-04-06 14:26:32', '2026-04-11 16:40:38', NULL),
(342, 358, 7, 'L2108', NULL, '2028-04-12', 590.00, 830.00, 0, 5, 2, 0, '2026-04-06 14:29:08', '2026-04-06 14:29:08', NULL),
(343, 359, 7, 'CP32', NULL, '2029-01-27', 282.50, 400.00, 0, 6, 4, 0, '2026-04-06 14:31:24', '2026-04-06 14:31:24', NULL),
(344, 360, 7, 'M1025015', NULL, '2027-09-12', 750.00, 1050.00, 0, 3, 1, 0, '2026-04-06 14:32:25', '2026-04-06 14:32:25', NULL),
(345, 361, 7, 'DFG3497A', NULL, '2028-04-30', 1551.67, 2200.00, 0, 6, 3, 0, '2026-04-06 14:35:51', '2026-04-06 14:35:51', NULL),
(346, 362, 7, '12012', NULL, '2027-11-11', 120.00, 170.00, 0, 5, 1, 0, '2026-04-06 14:37:45', '2026-04-06 14:37:45', NULL),
(347, 363, 7, '143J0229', NULL, '2029-08-12', 2195.00, 3100.00, 0, 2, 1, 0, '2026-04-06 14:41:11', '2026-04-06 14:41:11', NULL),
(348, 364, 7, '8364', NULL, '2027-12-31', 4750.00, 6650.00, 0, 4, 2, 0, '2026-04-06 14:45:29', '2026-04-06 14:45:29', NULL),
(349, 365, 7, '103G0929', NULL, '2029-06-12', 2360.00, 3300.00, 0, 2, 1, 0, '2026-04-06 14:47:29', '2026-04-06 14:47:29', NULL),
(350, 367, 7, 'GT0125016', NULL, '2028-05-12', 370.00, 520.00, 0, 40, 10, 0, '2026-04-06 14:49:41', '2026-04-06 14:49:41', NULL),
(351, 366, 7, '54B0328', NULL, '2028-01-31', 621.00, 900.00, 0, 2, 1, 0, '2026-04-06 14:50:53', '2026-04-06 14:50:53', NULL),
(352, 368, 7, 'GT0225040', NULL, '2028-07-12', 390.00, 550.00, 0, 46, 10, 0, '2026-04-06 14:52:12', '2026-04-20 08:34:59', NULL),
(353, 369, 7, '24GD05', NULL, '2027-09-30', 375.00, 530.00, 0, 1, 1, 0, '2026-04-06 14:54:30', '2026-04-06 14:54:30', NULL),
(354, 370, 7, '071124', NULL, '2028-12-12', 1220.00, 1750.00, 0, 10, 5, 0, '2026-04-06 14:56:22', '2026-04-06 14:56:22', NULL),
(355, 371, 7, 'N25L11', NULL, '2027-11-30', 2700.00, 3800.00, 0, 1, 1, 0, '2026-04-06 14:59:13', '2026-04-06 14:59:13', NULL),
(356, 372, 7, '6928623000341', NULL, '2028-12-12', 1160.00, 1650.00, 0, 10, 10, 0, '2026-04-06 15:00:32', '2026-04-06 15:00:32', NULL),
(357, 373, 7, 'D25I23', NULL, '2027-08-31', 3450.00, 4830.00, 0, 1, 1, 0, '2026-04-06 15:01:39', '2026-04-06 15:01:39', NULL),
(358, 375, 7, '66A0228', NULL, '2028-12-31', 1555.00, 2200.00, 0, 3, 2, 0, '2026-04-06 15:04:18', '2026-04-06 15:04:18', NULL),
(359, 374, 7, '11C465', NULL, '2028-11-12', 197.36, 300.00, 0, 36, 6, 0, '2026-04-06 15:04:34', '2026-04-06 15:04:34', NULL),
(360, 376, 7, 'FD25202B', NULL, '2028-08-31', 951.67, 1350.00, 0, 3, 3, 0, '2026-04-06 15:10:25', '2026-04-06 15:10:25', NULL),
(361, 377, 7, 'CF07535', NULL, '2028-06-30', 1536.60, 2150.00, 0, 20, 5, 0, '2026-04-06 15:13:12', '2026-04-11 11:59:41', NULL),
(362, 378, 7, 'AET-312', NULL, '2028-08-04', 2336.33, 3280.00, 0, 3, 3, 0, '2026-04-06 15:16:11', '2026-04-06 15:16:11', NULL),
(363, 379, 7, 'AET-291', NULL, '2028-08-31', 1355.30, 1900.00, 0, 3, 3, 0, '2026-04-06 15:20:09', '2026-04-06 15:20:09', NULL),
(364, 380, 7, '2571', NULL, '2030-11-30', 249.67, 350.00, 0, 6, 3, 0, '2026-04-06 15:24:38', '2026-04-06 15:24:38', NULL),
(365, 381, 7, 'XT5D014', NULL, '2028-03-31', 402.50, 600.00, 0, 4, 2, 0, '2026-04-06 15:27:59', '2026-04-06 15:27:59', NULL),
(366, 382, 7, 'ANNH0024', NULL, '2028-01-31', 1246.00, 1750.00, 0, 3, 3, 0, '2026-04-06 15:32:27', '2026-04-06 15:32:27', NULL),
(367, 383, 7, 'OP-005', NULL, '2027-07-01', 74.40, 100.00, 0, 20, 1, 1, '2026-04-06 15:35:43', '2026-04-17 13:29:58', NULL),
(368, 384, 7, '2061525', NULL, '2028-10-20', 565.00, 800.00, 0, 2, 1, 0, '2026-04-06 15:37:54', '2026-04-06 15:37:54', NULL),
(369, 386, 7, '25057', NULL, '2028-06-12', 410.00, 580.00, 0, 5, 1, 0, '2026-04-06 15:40:48', '2026-04-06 15:40:48', NULL),
(370, 385, 7, 'TSBH0058', NULL, '2028-03-31', 1426.67, 2000.00, 0, 3, 3, 0, '2026-04-06 15:43:25', '2026-04-06 15:43:25', NULL),
(371, 387, 7, 'FPO40425', NULL, '2028-02-12', 580.00, 812.00, 0, 6, 2, 0, '2026-04-06 15:44:06', '2026-04-06 15:44:06', NULL),
(372, 388, 7, 'BW0104', NULL, '2028-07-31', 450.00, 630.00, 0, 5, 2, 0, '2026-04-06 15:47:41', '2026-04-06 15:47:41', NULL),
(373, 391, 7, 'C52517', NULL, '2028-11-12', 590.00, 850.00, 0, 12, 2, 0, '2026-04-06 15:52:44', '2026-04-06 15:52:44', NULL),
(374, 390, 7, '2505141', NULL, '2028-05-31', 330.00, 470.00, 0, 10, 3, 0, '2026-04-06 15:53:22', '2026-04-06 15:53:22', NULL),
(375, 392, 7, '57A0128', NULL, '2028-12-12', 730.00, 1050.00, 0, 6, 2, 0, '2026-04-06 15:55:03', '2026-04-06 15:55:03', NULL),
(376, 393, 7, '60H0228', NULL, '2028-07-12', 785.00, 1100.00, 0, 6, 2, 0, '2026-04-06 15:57:26', '2026-04-06 15:57:26', NULL),
(377, 394, 7, '250775', NULL, '2028-07-31', 267.50, 380.00, 0, 10, 2, 0, '2026-04-06 16:01:04', '2026-04-06 16:01:04', NULL),
(378, 395, 7, '6156000152806', NULL, '2029-09-12', 290.00, 410.00, 0, 9, 2, 0, '2026-04-06 16:03:15', '2026-04-18 09:03:10', NULL),
(379, 396, 7, 'L5925', NULL, '2029-02-02', 530.00, 750.00, 0, 10, 2, 0, '2026-04-06 16:06:03', '2026-04-06 16:06:03', NULL),
(380, 397, 7, 'DZAHH0022', NULL, '2028-03-31', 3206.67, 4500.00, 0, 3, 3, 0, '2026-04-06 16:07:49', '2026-04-06 16:07:49', NULL),
(381, 398, 7, 'LG04E', NULL, '2028-11-12', 950.00, 1330.00, 0, 10, 2, 0, '2026-04-06 16:10:50', '2026-04-06 16:10:50', NULL),
(382, 399, 7, 'DZBHH0077', NULL, '2028-05-04', 4266.33, 6000.00, 0, 3, 3, 0, '2026-04-06 16:12:18', '2026-04-06 16:12:18', NULL),
(383, 400, 7, '5K256012', NULL, '2028-09-12', 1600.00, 2240.00, 0, 2, 1, 0, '2026-04-06 16:15:33', '2026-04-06 16:15:33', NULL),
(384, 401, 7, 'CF04566', NULL, '2028-03-31', 698.00, 1000.00, 0, 10, 5, 0, '2026-04-06 16:19:28', '2026-04-06 16:19:28', NULL),
(385, 402, 7, '25K1687', NULL, '2028-11-30', 3745.00, 5250.00, 0, 3, 3, 0, '2026-04-06 16:22:42', '2026-04-06 16:22:42', NULL),
(386, 403, 7, 'N-3533', NULL, '2028-11-30', 802.50, 2730.00, 0, 8, 4, 0, '2026-04-06 16:26:24', '2026-04-06 16:38:04', NULL),
(387, 404, 7, 'AJFA24007A', NULL, '2028-03-31', 1110.13, 1600.00, 0, 8, 2, 0, '2026-04-06 16:43:01', '2026-04-06 16:43:01', NULL),
(388, 405, 7, '25KB142', NULL, '2028-04-12', 552.08, 780.00, 0, 48, 10, 0, '2026-04-06 16:49:31', '2026-04-06 16:49:31', NULL),
(389, 406, 7, 'C0925002', NULL, '2028-08-31', 2496.67, 3500.00, 0, 3, 3, 0, '2026-04-06 16:50:37', '2026-04-06 16:50:37', NULL),
(390, 407, 7, 'L125E', NULL, '2028-09-02', 800.00, 1150.00, 0, 10, 2, 0, '2026-04-06 16:53:46', '2026-04-06 16:53:46', NULL),
(391, 408, 7, '018183', NULL, '2028-12-12', 610.00, 860.00, 0, 6, 1, 0, '2026-04-06 16:58:27', '2026-04-06 16:58:27', NULL),
(392, 409, 7, 'ABH5478', NULL, '2028-10-31', 8917.00, 12450.00, 0, 1, 1, 0, '2026-04-07 11:24:04', '2026-04-07 11:24:04', NULL),
(393, 410, 7, '5032', NULL, '2027-12-04', 5153.00, 7200.00, 0, 1, 1, 0, '2026-04-07 11:26:11', '2026-04-07 11:26:11', NULL),
(394, 411, 7, '4638', NULL, '2028-09-30', 3063.00, 4300.00, 0, 2, 1, 0, '2026-04-07 11:28:46', '2026-04-07 11:28:46', NULL),
(395, 412, 7, '330', NULL, '2027-12-31', 1285.00, 1700.00, 0, 2, 1, 0, '2026-04-07 11:34:49', '2026-04-07 11:34:49', NULL),
(396, 413, 7, '250236', NULL, '2028-02-29', 121.00, 200.00, 0, 10, 2, 0, '2026-04-07 11:39:09', '2026-04-07 11:39:09', NULL),
(397, 414, 7, '046', NULL, '2028-05-31', 2026.00, 2850.00, 0, 2, 1, 0, '2026-04-07 11:42:41', '2026-04-11 16:42:31', NULL),
(398, 415, 7, 'CE07655', NULL, '2027-06-30', 656.40, 950.00, 0, 9, 5, 0, '2026-04-07 11:46:28', '2026-04-18 08:59:56', NULL);
INSERT INTO `stock_items` (`id`, `drug_id`, `branch_id`, `batch_number`, `manufacturing_date`, `expiry_date`, `purchase_price`, `selling_price`, `vat_applicable`, `quantity_available`, `minimum_stock_level`, `reorder_point`, `created_at`, `updated_at`, `deleted_at`) VALUES
(399, 416, 7, 'E218619', NULL, '2028-12-31', 4191.50, 5900.00, 0, 2, 2, 0, '2026-04-07 11:52:27', '2026-04-07 11:52:27', NULL),
(400, 417, 7, 'E218475', NULL, '2029-12-31', 2043.00, 2860.20, 0, 2, 2, 0, '2026-04-07 11:55:35', '2026-04-07 11:55:35', NULL),
(401, 418, 7, 'XT5E008', NULL, '2029-04-30', 476.50, 700.00, 0, 4, 2, 0, '2026-04-07 11:59:33', '2026-04-07 11:59:33', NULL),
(402, 419, 7, 'MOCH0007', NULL, '2028-09-30', 1637.30, 2300.00, 0, 3, 3, 0, '2026-04-07 12:06:08', '2026-04-07 12:06:08', NULL),
(403, 420, 7, 'PH6751', NULL, '2029-12-12', 750.00, 1050.00, 0, 6, 2, 0, '2026-04-07 12:11:20', '2026-04-12 15:22:51', NULL),
(404, 421, 7, 'PK8755', NULL, '2030-01-31', 1284.00, 1800.00, 0, 4, 2, 0, '2026-04-07 12:14:00', '2026-04-07 12:14:00', NULL),
(405, 422, 7, '4TG28', NULL, '2027-06-30', 215.00, 300.00, 0, 4, 2, 0, '2026-04-07 12:24:07', '2026-04-07 12:24:07', NULL),
(406, 423, 7, 'VG05503', NULL, '2027-12-31', 3923.33, 5500.00, 0, 3, 3, 0, '2026-04-07 12:29:14', '2026-04-07 12:29:14', NULL),
(407, 424, 7, 'E2562501', NULL, '2028-02-29', 690.00, 1000.00, 0, 6, 2, 0, '2026-04-07 12:51:16', '2026-04-07 12:51:16', NULL),
(408, 425, 7, 'E3692501', NULL, '2028-02-29', 630.00, 890.00, 0, 6, 2, 0, '2026-04-07 12:59:06', '2026-04-07 12:59:06', NULL),
(409, 426, 7, '25298', NULL, '2028-09-30', 631.00, 900.00, 0, 2, 1, 0, '2026-04-07 13:04:01', '2026-04-07 13:04:01', NULL),
(410, 427, 7, '25003', NULL, '2027-09-30', 3565.00, 5000.00, 0, 3, 3, 0, '2026-04-07 13:08:19', '2026-04-07 13:08:19', NULL),
(411, 428, 7, 'XT5E029', NULL, '2029-04-30', 498.00, 700.00, 0, 4, 2, 0, '2026-04-07 13:15:39', '2026-04-07 13:15:39', NULL),
(412, 429, 7, 'XT5E014', NULL, '2029-04-05', 439.00, 625.00, 0, 4, 2, 0, '2026-04-07 13:18:12', '2026-04-07 13:18:12', NULL),
(413, 430, 7, 'BB389', NULL, '2027-10-31', 1498.00, 2100.00, 0, 2, 2, 0, '2026-04-07 13:22:41', '2026-04-07 13:22:41', NULL),
(414, 431, 7, 'BA2603', NULL, '2028-03-05', 856.00, 1200.00, 0, 2, 2, 0, '2026-04-07 13:24:55', '2026-04-07 13:24:55', NULL),
(415, 432, 7, '5E01348', NULL, '2028-05-31', 777.50, 1100.00, 0, 4, 2, 0, '2026-04-07 13:34:16', '2026-04-07 13:34:16', NULL),
(416, 433, 7, '5E01583', NULL, '2028-07-31', 697.50, 1000.00, 0, 4, 2, 0, '2026-04-07 13:42:43', '2026-04-07 13:42:43', NULL),
(417, 434, 7, 'S000671', NULL, '2030-05-31', 699.50, 1000.00, 0, 10, 4, 0, '2026-04-07 13:51:09', '2026-04-07 13:51:09', NULL),
(418, 435, 7, 'AAMY0001', NULL, '2028-03-31', 1569.33, 2200.00, 0, 3, 3, 0, '2026-04-07 13:58:08', '2026-04-07 13:58:08', NULL),
(419, 436, 7, 'XT5G034', NULL, '2028-06-05', 669.00, 950.00, 0, 4, 2, 0, '2026-04-07 14:02:48', '2026-04-07 14:02:48', NULL),
(420, 437, 7, '142m0128', NULL, '2028-11-30', 2708.00, 3800.00, 0, 1, 1, 0, '2026-04-07 14:05:26', '2026-04-07 14:05:26', NULL),
(421, 438, 7, 'lfg33916', NULL, '2028-09-20', 2583.00, 3357.90, 0, 3, 1, 0, '2026-04-07 14:05:40', '2026-04-07 14:05:40', NULL),
(422, 440, 7, '164B0129', NULL, '2029-01-31', 2718.00, 3800.00, 0, 1, 1, 0, '2026-04-07 14:12:23', '2026-04-07 14:12:23', NULL),
(423, 441, 7, 'LFG33317', NULL, '2028-07-25', 2583.00, 3357.90, 0, 3, 1, 0, '2026-04-07 14:16:04', '2026-04-07 14:16:04', NULL),
(424, 442, 7, 'ANHH0051', NULL, '2028-03-31', 1387.67, 1950.00, 0, 3, 3, 0, '2026-04-07 14:16:34', '2026-04-07 14:16:34', NULL),
(425, 444, 7, '48B0129', NULL, '2029-01-31', 1260.00, 1800.00, 0, 1, 1, 0, '2026-04-07 14:19:45', '2026-04-07 14:19:45', NULL),
(426, 443, 7, '854186-2', NULL, '2030-09-25', 2292.00, 2979.60, 0, 4, 2, 0, '2026-04-07 14:23:30', '2026-04-18 12:49:18', NULL),
(427, 445, 7, 'VE4091', NULL, '2027-09-30', 749.00, 1050.00, 0, 1, 1, 0, '2026-04-07 14:24:08', '2026-04-07 14:24:08', NULL),
(428, 447, 7, '291T01', NULL, '2028-07-31', 1070.00, 1500.00, 0, 4, 4, 0, '2026-04-07 14:27:04', '2026-04-07 14:27:04', NULL),
(429, 446, 7, '1300/01191/813', NULL, '2027-03-20', 1167.00, 1517.10, 0, 6, 2, 0, '2026-04-07 14:28:56', '2026-04-07 14:28:56', NULL),
(430, 448, 7, '292T02', NULL, '2027-12-31', 1203.75, 1700.00, 0, 4, 4, 0, '2026-04-07 14:29:38', '2026-04-07 14:29:38', NULL),
(431, 449, 7, 'y-730', NULL, '2030-03-05', 500.00, 650.00, 0, 12, 5, 0, '2026-04-07 14:31:43', '2026-04-07 14:31:43', NULL),
(432, 450, 7, '233T03', NULL, '2028-06-30', 1391.00, 1950.00, 0, 4, 4, 0, '2026-04-07 14:33:19', '2026-04-07 14:33:19', NULL),
(433, 451, 7, 'jl-033', NULL, '2030-04-22', 1000.00, 1300.00, 0, 3, 1, 0, '2026-04-07 14:34:05', '2026-04-07 14:34:05', NULL),
(434, 452, 7, '234-0', NULL, '2030-06-24', 1500.00, 1950.00, 0, 2, 0, 0, '2026-04-07 14:36:55', '2026-04-07 14:36:55', NULL),
(435, 453, 7, 'CAG02AAA', NULL, '2028-01-31', 2140.00, 3000.00, 0, 3, 3, 0, '2026-04-07 14:38:06', '2026-04-07 14:38:06', NULL),
(436, 454, 7, '26042', NULL, '2027-11-02', 3791.00, 4928.30, 0, 12, 5, 0, '2026-04-07 14:44:47', '2026-04-07 14:44:47', NULL),
(437, 455, 7, 'G015462', NULL, '2027-10-31', 1783.33, 2500.00, 0, 3, 3, 0, '2026-04-07 14:46:05', '2026-04-07 14:46:05', NULL),
(438, 457, 7, 'NA8598', NULL, '2028-01-31', 1361.67, 1910.00, 0, 3, 3, 0, '2026-04-07 14:49:49', '2026-04-07 14:49:49', NULL),
(439, 456, 7, '5003345', NULL, '2028-11-10', 508.00, 660.40, 0, 12, 3, 0, '2026-04-07 14:50:33', '2026-04-07 14:50:33', NULL),
(440, 458, 7, '1050033328', NULL, '2026-10-06', 508.00, 660.40, 0, 12, 3, 0, '2026-04-07 14:55:09', '2026-04-07 14:55:09', NULL),
(441, 459, 7, 'S260121', NULL, '2026-07-20', 833.00, 1082.90, 0, 12, 3, 0, '2026-04-08 08:54:50', '2026-04-08 08:54:50', NULL),
(442, 461, 7, 'bf233', NULL, '2027-03-17', 496.00, 600.16, 0, 46, 10, 0, '2026-04-08 09:05:12', '2026-04-18 15:21:19', NULL),
(443, 462, 7, 'l6026566aw', NULL, '2026-07-25', 500.00, 650.00, 0, 11, 5, 0, '2026-04-08 09:16:07', '2026-04-14 12:42:22', NULL),
(444, 463, 7, 'az5', NULL, '2026-08-19', 383.00, 501.73, 0, 33, 12, 0, '2026-04-08 09:20:11', '2026-04-18 11:38:26', NULL),
(445, 464, 7, 'az2', NULL, '2026-09-30', 383.00, 501.73, 0, 35, 12, 0, '2026-04-08 09:23:45', '2026-04-20 12:36:36', NULL),
(446, 465, 7, 'ak6', NULL, '2026-11-05', 454.00, 594.74, 0, 22, 5, 0, '2026-04-08 09:29:56', '2026-04-20 12:36:36', NULL),
(447, 466, 7, 'b72', NULL, '2027-02-13', 475.00, 570.00, 0, 40, 10, 0, '2026-04-08 09:43:30', '2026-04-08 09:43:30', NULL),
(448, 467, 7, 'C11', NULL, '2027-03-03', 370.00, 451.40, 0, 40, 10, 0, '2026-04-08 10:09:29', '2026-04-08 10:09:29', NULL),
(449, 468, 7, 'b81', NULL, '2027-01-16', 270.00, 351.00, 0, 40, 10, 0, '2026-04-08 10:13:34', '2026-04-08 10:13:34', NULL),
(450, 469, 7, 'c42', NULL, '2027-02-27', 245.00, 306.25, 0, 40, 10, 0, '2026-04-08 10:25:37', '2026-04-08 10:25:37', NULL),
(451, 470, 7, '12/2025', NULL, '2027-12-20', 325.00, 422.50, 0, 20, 5, 0, '2026-04-08 10:37:26', '2026-04-08 10:37:26', NULL),
(452, 471, 7, '52811092', NULL, '2027-10-08', 7500.00, 9800.00, 0, 3, 1, 0, '2026-04-08 10:43:20', '2026-04-08 10:43:20', NULL),
(453, 472, 7, 'BA07582', NULL, '2031-01-06', 2500.00, 3000.00, 0, 3, 0, 0, '2026-04-08 10:52:38', '2026-04-08 10:52:38', NULL),
(455, 473, 7, 'p55', NULL, '2029-11-22', 1000.00, 1250.00, 0, 3, 1, 0, '2026-04-08 12:24:05', '2026-04-08 12:24:05', NULL),
(456, 474, 7, '012', NULL, '2028-07-07', 1583.00, 2000.00, 0, 6, 2, 0, '2026-04-08 12:38:53', '2026-04-08 12:38:53', NULL),
(457, 475, 7, 'FIU31N', NULL, '2028-10-30', 500.00, 650.00, 0, 6, 1, 0, '2026-04-08 12:45:21', '2026-04-08 12:45:21', NULL),
(458, 476, 7, 'HDU05', NULL, '2028-11-30', 833.00, 1100.00, 0, 6, 2, 0, '2026-04-08 12:51:56', '2026-04-08 12:51:56', NULL),
(460, 477, 7, 'vv-0326', NULL, '2028-03-30', 376.00, 500.00, 0, 17, 6, 0, '2026-04-08 13:00:50', '2026-04-20 08:17:52', NULL),
(461, 478, 7, 'vv0226', NULL, '2028-02-29', 1687.00, 2100.00, 0, 7, 2, 0, '2026-04-08 13:07:54', '2026-04-08 13:07:54', NULL),
(462, 479, 7, 'L310', NULL, '2028-06-18', 416.00, 550.00, 0, 6, 2, 0, '2026-04-08 13:15:09', '2026-04-08 13:15:09', NULL),
(464, 480, 7, 'L306;35', NULL, '2028-07-14', 416.00, 550.00, 0, 6, 2, 0, '2026-04-08 13:20:18', '2026-04-08 13:20:18', NULL),
(465, 482, 7, '04-90', NULL, '2026-08-30', 1500.00, 1800.00, 0, 12, 5, 0, '2026-04-08 13:29:35', '2026-04-08 13:29:35', NULL),
(466, 483, 7, '260711', NULL, '2029-09-02', 625.00, 750.00, 0, 12, 4, 0, '2026-04-08 13:33:14', '2026-04-08 13:33:14', NULL),
(467, 484, 7, '25477', NULL, '2028-05-23', 1150.00, 1350.00, 0, 10, 3, 0, '2026-04-08 13:39:54', '2026-04-08 13:39:54', NULL),
(468, 485, 7, '20260333', NULL, '2027-05-05', 4083.00, 4900.00, 0, 6, 2, 0, '2026-04-08 13:54:34', '2026-04-08 13:54:34', NULL),
(470, 486, 7, '1A050226', NULL, '2027-02-04', 2800.00, 3350.00, 0, 5, 2, 0, '2026-04-08 14:21:12', '2026-04-08 14:21:12', NULL),
(471, 487, 7, '04-95 4GH', NULL, '2027-06-16', 2083.00, 2500.00, 0, 12, 5, 0, '2026-04-08 14:26:43', '2026-04-08 14:26:43', NULL),
(472, 488, 7, '3131WIC', NULL, '2026-08-25', 2666.00, 3300.00, 0, 2, 1, 0, '2026-04-08 14:30:31', '2026-04-18 12:49:18', NULL),
(473, 489, 7, '23A26DP1', NULL, '2027-10-14', 2785.00, 3500.00, 0, 7, 2, 0, '2026-04-08 14:35:11', '2026-04-08 14:35:11', NULL),
(474, 490, 7, 'CN121L', NULL, '2028-09-09', 1416.00, 1700.00, 0, 12, 4, 0, '2026-04-08 14:40:27', '2026-04-08 14:40:27', NULL),
(475, 491, 7, '092', NULL, '2028-02-29', 750.00, 1050.00, 0, 10, 3, 0, '2026-04-08 14:45:11', '2026-04-08 14:45:11', NULL),
(476, 492, 7, '10GS1F BN05', NULL, '2027-05-25', 2833.00, 3500.00, 0, 6, 2, 0, '2026-04-08 14:52:14', '2026-04-08 14:52:14', NULL),
(477, 493, 7, '084726A', NULL, '2027-11-01', 800.00, 1050.00, 0, 10, 3, 0, '2026-04-08 14:59:42', '2026-04-08 14:59:42', NULL),
(478, 494, 7, 'SK0226', NULL, '2028-02-29', 365.00, 500.00, 0, 26, 8, 0, '2026-04-09 07:25:07', '2026-04-09 07:25:07', NULL),
(479, 495, 7, 'GMF1225', NULL, '2027-12-31', 1643.00, 2200.00, 0, 7, 2, 0, '2026-04-09 07:30:31', '2026-04-09 07:30:31', NULL),
(481, 497, 7, 'AK2', NULL, '2026-08-13', 391.00, 500.00, 0, 11, 5, 0, '2026-04-09 07:46:38', '2026-04-20 09:33:46', NULL),
(482, 498, 7, 'AZ25', NULL, '2026-08-29', 391.00, 500.00, 0, 10, 5, 0, '2026-04-09 07:50:23', '2026-04-20 13:03:54', NULL),
(483, 499, 7, 'AZ2', NULL, '2026-07-27', 241.00, 350.00, 0, 12, 0, 5, '2026-04-09 07:53:26', '2026-04-09 07:53:26', NULL),
(484, 500, 7, 'AZ2', NULL, '2026-06-17', 241.00, 350.00, 0, 12, 5, 0, '2026-04-09 08:03:44', '2026-04-09 08:03:44', NULL),
(485, 501, 7, 'AZ2', NULL, '2026-07-25', 241.00, 350.00, 0, 12, 5, 0, '2026-04-09 08:06:05', '2026-04-09 08:06:05', NULL),
(486, 502, 7, '10HOP7B', NULL, '2027-03-26', 730.00, 850.00, 0, 24, 10, 0, '2026-04-09 08:12:54', '2026-04-09 08:12:54', NULL),
(487, 503, 7, 'BA06326', NULL, '2029-11-22', 800.00, 1100.00, 0, 6, 2, 0, '2026-04-09 08:20:10', '2026-04-09 08:20:10', NULL),
(488, 505, 7, '8801038586755', NULL, '2030-12-26', 170.00, 250.00, 0, 20, 5, 0, '2026-04-09 08:29:25', '2026-04-09 08:29:25', NULL),
(489, 506, 7, 'FA06626', NULL, '2030-11-27', 180.00, 250.00, 0, 10, 5, 0, '2026-04-09 08:34:52', '2026-04-09 08:34:52', NULL),
(490, 507, 7, '6932620208099', NULL, '2031-01-02', 1000.00, 1500.00, 0, 12, 3, 0, '2026-04-09 08:45:17', '2026-04-09 08:45:17', NULL),
(491, 508, 7, 'MC1023', NULL, '2026-12-08', 125.00, 200.00, 0, 22, 10, 0, '2026-04-09 09:38:20', '2026-04-14 12:42:22', NULL),
(492, 509, 7, 'MC4250', NULL, '2027-03-04', 115.00, 200.00, 0, 26, 10, 0, '2026-04-09 09:44:28', '2026-04-09 09:44:28', NULL),
(494, 510, 7, '2B247', NULL, '2027-05-17', 777.00, 1000.00, 0, 5, 2, 0, '2026-04-09 09:53:08', '2026-04-09 09:53:08', NULL),
(495, 511, 7, '28330', NULL, '2027-01-23', 776.00, 1000.00, 0, 5, 0, 0, '2026-04-09 09:57:17', '2026-04-09 09:57:17', NULL),
(496, 512, 7, '2A530', NULL, '2027-01-24', 777.00, 1000.00, 0, 5, 2, 0, '2026-04-09 10:05:00', '2026-04-09 10:05:00', NULL),
(497, 513, 7, '2025307', NULL, '2027-11-01', 87.00, 100.00, 0, 50, 10, 0, '2026-04-09 10:10:30', '2026-04-14 14:57:32', NULL),
(498, 514, 7, 'ZH01504-1', NULL, '2027-04-20', 291.00, 400.00, 0, 24, 5, 0, '2026-04-09 10:19:50', '2026-04-09 10:19:50', NULL),
(499, 515, 7, 'KLF251005', NULL, '2027-10-04', 104.00, 150.00, 0, 148, 10, 0, '2026-04-09 10:22:55', '2026-04-09 10:22:55', NULL),
(500, 516, 7, 'MC2-020 14D', NULL, '2027-01-13', 2200.00, 2850.00, 0, 5, 2, 0, '2026-04-09 10:27:59', '2026-04-09 10:27:59', NULL),
(501, 517, 7, 'MC2-202 12D', NULL, '2026-11-11', 1200.00, 1700.00, 0, 10, 4, 0, '2026-04-09 10:31:52', '2026-04-09 10:31:52', NULL),
(502, 518, 7, '06/6D', NULL, '2028-02-06', 300.00, 450.00, 0, 4, 2, 0, '2026-04-09 10:38:28', '2026-04-20 12:37:59', NULL),
(503, 520, 7, 'PI0925', NULL, '2027-08-31', 1000.00, 1500.00, 0, 3, 1, 0, '2026-04-09 10:53:04', '2026-04-09 10:53:04', NULL),
(504, 521, 7, 'ZH01250812', NULL, '2027-08-08', 1000.00, 1300.00, 0, 2, 1, 0, '2026-04-09 10:58:25', '2026-04-20 12:36:36', NULL),
(505, 522, 7, 'ZH01250813', NULL, '2027-08-08', 1000.00, 1300.00, 0, 3, 1, 0, '2026-04-09 11:03:10', '2026-04-09 11:03:10', NULL),
(506, 523, 7, '12/2N', NULL, '2027-06-15', 20.00, 25.00, 0, 93, 10, 0, '2026-04-09 11:08:28', '2026-04-18 17:38:49', NULL),
(507, 524, 7, '50/5D', NULL, '2027-03-10', 20.00, 25.00, 0, 95, 10, 0, '2026-04-09 11:11:42', '2026-04-09 11:11:42', NULL),
(508, 525, 7, 'OCN0355036', NULL, '2026-12-10', 25.00, 50.00, 0, 40, 10, 0, '2026-04-09 11:17:14', '2026-04-09 11:17:14', NULL),
(509, 526, 7, 'OCN0351824', NULL, '2026-06-26', 25.00, 50.00, 0, 79, 10, 0, '2026-04-09 11:21:08', '2026-04-20 08:17:52', NULL),
(510, 527, 7, '53150324HI', NULL, '2026-11-30', 20.00, 25.00, 0, 58, 10, 0, '2026-04-09 11:28:28', '2026-04-18 17:15:35', NULL),
(511, 528, 7, '52810324HI', NULL, '2026-10-31', 20.00, 25.00, 0, 56, 10, 0, '2026-04-09 11:30:51', '2026-04-20 08:17:52', NULL),
(512, 529, 7, 'AJ02X', NULL, '2026-10-05', 342.00, 500.00, 0, 24, 10, 0, '2026-04-09 11:56:17', '2026-04-09 11:56:17', NULL),
(513, 530, 7, 'A00854', NULL, '2026-06-30', 625.00, 700.00, 0, 12, 1, 0, '2026-04-09 12:00:33', '2026-04-09 12:00:33', NULL),
(514, 531, 7, 'AJ01X', NULL, '2026-09-02', 341.00, 500.00, 0, 12, 3, 0, '2026-04-09 12:03:56', '2026-04-09 12:03:56', NULL),
(515, 532, 7, 'AJ04X', NULL, '2026-09-02', 341.00, 500.00, 0, 12, 5, 0, '2026-04-09 12:06:29', '2026-04-09 12:06:29', NULL),
(516, 533, 7, '0925P', NULL, '2030-11-19', 5833.00, 7500.00, 0, 3, 1, 0, '2026-04-09 12:11:29', '2026-04-09 12:11:29', NULL),
(517, 534, 7, 'PS0061215', NULL, '2030-11-28', 5167.00, 6700.00, 0, 3, 1, 0, '2026-04-09 12:15:10', '2026-04-09 12:15:10', NULL),
(518, 535, 7, '0103', NULL, '2026-07-07', 566.00, 700.00, 0, 12, 3, 0, '2026-04-09 12:36:59', '2026-04-09 12:36:59', NULL),
(519, 536, 7, '0106', NULL, '2026-08-03', 566.00, 700.00, 0, 12, 3, 0, '2026-04-09 12:39:32', '2026-04-09 12:39:32', NULL),
(520, 537, 7, '3838952002462', NULL, '2030-11-05', 250.00, 350.00, 0, 10, 3, 0, '2026-04-09 12:48:11', '2026-04-09 12:48:11', NULL),
(521, 538, 7, '5030481970238', NULL, '2030-10-26', 250.00, 350.00, 0, 10, 3, 0, '2026-04-09 12:53:14', '2026-04-09 12:53:14', NULL),
(522, 539, 7, '5011417551721', NULL, '2028-07-26', 3375.00, 4300.00, 0, 4, 1, 0, '2026-04-09 13:01:38', '2026-04-09 13:01:38', NULL),
(523, 540, 7, '4084500342064', NULL, '2027-12-25', 3753.00, 4500.00, 0, 2, 1, 0, '2026-04-09 13:09:05', '2026-04-09 13:09:05', NULL),
(524, 541, 7, '03LCI', NULL, '2028-12-31', 916.00, 1200.00, 0, 3, 1, 0, '2026-04-09 13:11:59', '2026-04-09 13:11:59', NULL),
(525, 542, 7, '02LCI', NULL, '2028-12-31', 916.00, 1200.00, 0, 3, 1, 0, '2026-04-09 13:16:08', '2026-04-09 13:16:08', NULL),
(526, 543, 7, 'M39HEM-7154-E0', NULL, '2032-11-30', 94700.00, 125000.00, 0, 2, 1, 0, '2026-04-09 13:22:07', '2026-04-09 13:22:07', NULL),
(527, 544, 7, 'LAPL30-17', NULL, '2030-01-01', 1300.00, 1700.00, 0, 6, 2, 0, '2026-04-09 13:52:07', '2026-04-09 13:52:07', NULL),
(528, 545, 7, 'B20241120', NULL, '2027-11-24', 1041.00, 1300.00, 0, 12, 4, 0, '2026-04-09 14:00:33', '2026-04-09 14:00:33', NULL),
(529, 546, 7, 'NSI345', NULL, '2028-03-02', 1187.00, 1500.00, 0, 6, 2, 0, '2026-04-09 14:05:53', '2026-04-09 14:05:53', NULL),
(530, 547, 7, '029', NULL, '2028-09-26', 1000.00, 1200.00, 0, 4, 2, 0, '2026-04-09 14:13:10', '2026-04-14 14:57:32', NULL),
(531, 548, 7, '6156000346076', NULL, '2027-02-02', 1030.00, 1150.00, 0, 4, 2, 0, '2026-04-09 14:23:05', '2026-04-18 11:30:40', NULL),
(532, 549, 7, 'G014294', NULL, '2027-08-31', 1212.67, 1700.00, 0, 3, 3, 0, '2026-04-10 12:52:54', '2026-04-10 12:52:54', NULL),
(533, 550, 7, '9595E1', NULL, '2028-09-01', 4708.00, 6600.00, 0, 1, 1, 0, '2026-04-10 12:57:33', '2026-04-10 12:57:33', NULL),
(534, 551, 7, 'ADQA25003A', NULL, '2028-12-01', 1070.00, 1500.00, 0, 2, 2, 0, '2026-04-10 13:02:07', '2026-04-10 13:02:07', NULL),
(535, 552, 7, '987', NULL, '2030-05-20', 4500.00, 6300.00, 0, 1, 0, 0, '2026-04-10 13:05:56', '2026-04-10 13:05:56', NULL),
(536, 553, 7, 'AUNH0025', NULL, '2027-09-30', 1141.33, 1600.00, 0, 3, 3, 0, '2026-04-10 13:08:17', '2026-04-10 13:08:17', NULL),
(537, 554, 7, '24GD05', NULL, '2027-09-10', 375.00, 550.00, 0, 1, 1, 0, '2026-04-10 13:12:31', '2026-04-10 13:12:31', NULL),
(538, 555, 7, 'P0007858', NULL, '2026-06-12', 1450.00, 2050.00, 0, 6, 2, 0, '2026-04-10 13:13:55', '2026-04-10 13:13:55', NULL),
(539, 556, 7, 'A250468', NULL, '2028-10-31', 650.00, 950.00, 0, 3, 3, 0, '2026-04-10 13:15:17', '2026-04-10 13:15:17', NULL),
(540, 557, 7, 'A250484', NULL, '2028-10-31', 1120.00, 1600.00, 0, 3, 3, 0, '2026-04-10 13:17:19', '2026-04-10 13:17:19', NULL),
(541, 558, 7, 'KPS25120', NULL, '2028-09-12', 490.00, 700.00, 0, 4, 1, 0, '2026-04-10 13:17:48', '2026-04-10 13:17:48', NULL),
(542, 559, 7, '20250301', NULL, '2028-03-30', 2900.00, 4100.00, 0, 9, 2, 0, '2026-04-10 13:21:28', '2026-04-18 13:54:58', NULL),
(543, 560, 7, '535451', NULL, '2028-02-29', 909.50, 1300.00, 0, 2, 2, 0, '2026-04-10 13:21:38', '2026-04-10 13:21:38', NULL),
(544, 561, 7, 'KK135', NULL, '2029-02-12', 435.00, 600.00, 0, 4, 1, 0, '2026-04-10 13:24:52', '2026-04-18 15:45:41', NULL),
(545, 562, 7, 'EMX1323', NULL, '2027-09-30', 12225.00, 17150.00, 0, 2, 2, 0, '2026-04-10 13:25:46', '2026-04-10 13:25:46', NULL),
(546, 563, 7, 'PF8002', NULL, '2027-08-31', 2140.00, 3000.00, 0, 12, 3, 0, '2026-04-10 13:29:15', '2026-04-18 11:39:38', NULL),
(547, 564, 7, 'FLB00045', NULL, '2027-12-12', 5850.00, 8200.00, 0, 1, 0, 0, '2026-04-10 13:29:33', '2026-04-10 13:29:33', NULL),
(548, 565, 7, '25207', NULL, '2028-07-31', 797.50, 1150.00, 0, 4, 2, 0, '2026-04-10 13:32:16', '2026-04-10 13:32:16', NULL),
(549, 566, 7, '24k25d1', NULL, '2027-11-12', 2750.00, 3850.00, 0, 6, 1, 0, '2026-04-10 13:33:33', '2026-04-10 13:33:33', NULL),
(550, 567, 7, '0PD25003', NULL, '2027-10-31', 2675.00, 3750.00, 0, 1, 1, 0, '2026-04-10 13:36:31', '2026-04-10 13:36:31', NULL),
(551, 568, 7, '240721', NULL, '2027-07-12', 870.00, 1250.00, 0, 9, 2, 0, '2026-04-10 13:38:07', '2026-04-18 09:03:10', NULL),
(552, 569, 7, '25FA153', NULL, '2028-04-30', 2944.50, 4150.00, 0, 4, 2, 0, '2026-04-10 13:40:42', '2026-04-10 13:40:42', NULL),
(553, 570, 7, 'JK00006', NULL, '2030-06-12', 520.00, 750.00, 0, 5, 1, 0, '2026-04-10 13:42:51', '2026-04-10 13:42:51', NULL),
(554, 571, 7, 'CLA406', NULL, '2028-11-12', 1440.00, 2050.00, 0, 5, 1, 0, '2026-04-10 13:46:11', '2026-04-10 13:46:11', NULL),
(555, 572, 7, '352F63', NULL, '2027-11-10', 1963.00, 2750.00, 0, 3, 3, 0, '2026-04-10 13:47:02', '2026-04-10 13:47:02', NULL),
(556, 573, 7, '4373929', NULL, '2027-05-12', 1240.00, 1750.00, 0, 5, 1, 0, '2026-04-10 13:49:03', '2026-04-10 13:49:03', NULL),
(557, 574, 7, 'YX0755', NULL, '2028-04-30', 3853.67, 5400.00, 0, 3, 3, 0, '2026-04-10 13:50:40', '2026-04-10 13:50:40', NULL),
(558, 575, 7, '5373552', NULL, '2028-08-12', 316.75, 450.00, 0, 19, 5, 0, '2026-04-10 13:52:39', '2026-04-18 17:15:35', NULL),
(559, 576, 7, 'VL5156', NULL, '2027-11-10', 1055.00, 1500.00, 0, 1, 1, 0, '2026-04-10 13:55:23', '2026-04-10 13:55:23', NULL),
(560, 577, 7, 'T3ABC089', NULL, '2027-05-12', 142.00, 200.00, 0, 8, 2, 0, '2026-04-10 13:55:56', '2026-04-20 08:34:59', NULL),
(561, 578, 7, '50103019', NULL, '2028-07-31', 286.00, 400.00, 0, 20, 10, 0, '2026-04-10 13:58:47', '2026-04-10 13:58:47', NULL),
(562, 579, 7, '023A2511X', NULL, '2028-08-12', 270.00, 400.00, 0, 10, 2, 0, '2026-04-10 13:59:37', '2026-04-10 13:59:37', NULL),
(563, 581, 7, '316250505', NULL, '2028-04-30', 350.00, 500.00, 0, 4, 2, 0, '2026-04-10 14:02:42', '2026-04-20 13:03:54', NULL),
(564, 580, 7, 'N-3382', NULL, '2028-03-20', 730.00, 1050.00, 0, 3, 1, 0, '2026-04-10 14:02:43', '2026-04-20 12:37:59', NULL),
(565, 583, 7, 'E5005', NULL, '2027-08-31', 3033.33, 4250.00, 0, 6, 3, 0, '2026-04-10 14:06:44', '2026-04-10 14:06:44', NULL),
(566, 582, 7, 'TCUT-003', NULL, '2029-07-12', 283.33, 400.06, 0, 9, 2, 0, '2026-04-10 14:06:51', '2026-04-10 14:06:51', NULL),
(567, 584, 7, 'MP24435', NULL, '2028-07-12', 214.00, 300.00, 0, 10, 2, 0, '2026-04-10 14:10:40', '2026-04-10 14:10:40', NULL),
(568, 585, 7, 'IC01E5001', NULL, '2028-03-31', 2211.33, 3100.00, 0, 3, 3, 0, '2026-04-10 14:12:55', '2026-04-10 14:12:55', NULL),
(569, 586, 7, '2501014A', NULL, '2027-12-11', 3200.00, 4500.00, 0, 4, 1, 0, '2026-04-10 14:14:32', '2026-04-10 14:14:32', NULL),
(570, 587, 7, 'T1ADR105', NULL, '2027-10-12', 4000.00, 5600.00, 0, 2, 1, 0, '2026-04-10 14:18:13', '2026-04-10 14:18:13', NULL),
(571, 589, 7, 'T1AFN009', NULL, '2027-12-20', 1330.00, 1900.00, 0, 10, 1, 0, '2026-04-10 14:21:59', '2026-04-12 12:40:34', NULL),
(572, 588, 7, 'A250539', NULL, '2027-11-30', 645.33, 950.00, 0, 3, 3, 0, '2026-04-10 14:22:26', '2026-04-10 14:22:26', NULL),
(573, 590, 7, 'TBBH0046', NULL, '2027-10-31', 1855.00, 2600.00, 0, 3, 3, 0, '2026-04-10 14:25:25', '2026-04-10 14:25:25', NULL),
(574, 591, 7, 'T3ACH018', NULL, '2028-05-12', 2300.00, 3220.00, 0, 10, 5, 0, '2026-04-10 14:25:26', '2026-04-10 14:25:26', NULL),
(575, 592, 7, '25K0633', NULL, '2028-11-30', 4458.33, 6250.00, 0, 3, 3, 0, '2026-04-10 14:29:36', '2026-04-10 14:29:36', NULL),
(576, 593, 7, 'IC97E4029', NULL, '2027-10-20', 645.00, 900.00, 0, 5, 1, 0, '2026-04-10 14:35:50', '2026-04-10 14:35:50', NULL),
(577, 594, 7, '250309', NULL, '2028-02-29', 58.90, 100.00, 0, 10, 5, 0, '2026-04-10 14:37:24', '2026-04-10 14:37:24', NULL),
(578, 596, 7, 'LA250322', NULL, '2028-01-06', 4280.00, 6000.00, 0, 5, 2, 0, '2026-04-10 14:49:31', '2026-04-10 14:49:31', NULL),
(579, 595, 7, 'E1C0006', NULL, '2028-07-12', 1600.00, 2250.00, 0, 5, 1, 0, '2026-04-10 14:51:10', '2026-04-10 14:51:10', NULL),
(580, 597, 7, 'F3025012', NULL, '2027-09-30', 856.00, 1200.00, 0, 1, 1, 0, '2026-04-10 14:52:43', '2026-04-10 14:52:43', NULL),
(581, 598, 7, '344248', NULL, '2030-08-12', 310.80, 450.00, 0, 46, 2, 0, '2026-04-10 14:55:33', '2026-04-20 08:34:59', NULL),
(582, 599, 7, '250857', NULL, '2028-08-31', 39.50, 100.00, 0, 10, 5, 0, '2026-04-10 14:55:53', '2026-04-10 14:55:53', NULL),
(583, 600, 7, '344226', NULL, '2030-07-12', 348.00, 500.00, 0, 23, 5, 0, '2026-04-10 14:58:13', '2026-04-20 08:34:59', NULL),
(584, 601, 7, '53B25034A', NULL, '2027-06-30', 963.00, 1350.00, 0, 10, 2, 0, '2026-04-10 15:01:02', '2026-04-10 15:01:02', NULL),
(585, 602, 7, '74A0128', NULL, '2028-12-31', 2140.00, 3000.00, 0, 1, 1, 0, '2026-04-10 15:02:59', '2026-04-10 15:02:59', NULL),
(586, 603, 7, '123M03', NULL, '2028-08-31', 8560.00, 12000.00, 0, 1, 1, 0, '2026-04-10 15:06:30', '2026-04-10 15:06:30', NULL),
(587, 604, 7, '251123', NULL, '2028-11-30', 49.00, 100.00, 0, 10, 2, 0, '2026-04-10 15:09:44', '2026-04-10 15:09:44', NULL),
(588, 605, 7, 'ME012', NULL, '2027-04-12', 1950.00, 2750.00, 0, 5, 1, 0, '2026-04-10 15:15:47', '2026-04-10 15:15:47', NULL),
(589, 606, 7, '827T11', NULL, '2029-05-31', 767.67, 1100.00, 0, 3, 3, 0, '2026-04-10 15:19:53', '2026-04-10 15:19:53', NULL),
(592, 607, 7, '25K002DH36', NULL, '2027-09-12', 650.00, 900.00, 0, 6, 1, 0, '2026-04-10 15:21:37', '2026-04-10 15:21:37', NULL),
(593, 608, 7, '470T13', NULL, '2029-04-30', 1266.33, 1800.00, 0, 3, 3, 0, '2026-04-10 15:23:54', '2026-04-10 15:23:54', NULL),
(594, 609, 7, 'T13625', NULL, '2027-06-12', 670.00, 950.00, 0, 5, 1, 0, '2026-04-10 15:25:15', '2026-04-10 15:25:15', NULL),
(595, 610, 7, '250447', NULL, '2028-04-10', 45.00, 100.00, 0, 10, 2, 0, '2026-04-10 15:27:44', '2026-04-10 15:27:44', NULL),
(596, 612, 7, '25110', NULL, '2028-11-30', 61.00, 100.00, 0, 10, 2, 0, '2026-04-10 15:30:22', '2026-04-10 15:30:22', NULL),
(597, 611, 7, 'RBC502', NULL, '2028-05-12', 750.00, 1050.00, 0, 4, 1, 0, '2026-04-10 15:30:53', '2026-04-10 15:30:53', NULL),
(598, 614, 7, '10H0729', NULL, '2029-07-12', 880.00, 1250.00, 0, 5, 1, 0, '2026-04-10 15:35:18', '2026-04-10 15:35:18', NULL),
(599, 613, 7, '250536', NULL, '2028-05-31', 685.10, 1000.00, 0, 10, 5, 0, '2026-04-10 15:35:32', '2026-04-10 15:35:32', NULL),
(600, 616, 7, 'G250006', NULL, '2027-12-12', 590.00, 850.00, 0, 4, 1, 0, '2026-04-10 15:40:14', '2026-04-10 15:40:14', NULL),
(601, 615, 7, 'ZST25082', NULL, '2028-09-30', 85.00, 150.00, 0, 10, 5, 0, '2026-04-10 15:40:24', '2026-04-10 15:40:24', NULL),
(602, 617, 7, '23', NULL, '2027-12-31', 1248.00, 1750.00, 0, 2, 1, 0, '2026-04-10 15:43:18', '2026-04-10 15:43:18', NULL),
(603, 618, 7, '55D4020', NULL, '2029-03-01', 450.00, 650.00, 0, 20, 5, 0, '2026-04-10 15:44:50', '2026-04-17 13:05:06', NULL),
(604, 619, 7, '390702', NULL, '2029-02-28', 2160.00, 3050.00, 0, 3, 1, 0, '2026-04-10 15:46:24', '2026-04-10 15:46:24', NULL),
(605, 620, 7, '20251115', NULL, '2028-11-14', 770.00, 1100.00, 0, 10, 2, 0, '2026-04-10 15:50:03', '2026-04-10 15:50:03', NULL),
(606, 621, 7, '1150825', NULL, '2028-06-12', 1980.00, 2800.00, 0, 10, 2, 0, '2026-04-10 15:50:22', '2026-04-10 15:50:22', NULL),
(607, 622, 7, '2503031', NULL, '2028-03-31', 9240.00, 12950.00, 0, 2, 1, 0, '2026-04-10 15:53:05', '2026-04-12 15:27:17', NULL),
(608, 623, 7, 'M4286', NULL, '2027-09-12', 1300.00, 1850.00, 0, 5, 1, 0, '2026-04-10 15:56:51', '2026-04-10 15:56:51', NULL),
(609, 624, 7, 'TAMS56002', NULL, '2028-09-30', 2496.67, 3500.00, 0, 3, 3, 0, '2026-04-10 15:58:29', '2026-04-10 15:58:29', NULL),
(610, 626, 7, '25L001TC63', NULL, '2028-10-31', 360.00, 500.00, 0, 12, 1, 0, '2026-04-10 16:02:11', '2026-04-12 11:13:57', NULL),
(611, 625, 7, '25L1440', NULL, '2028-12-10', 13589.00, 19050.00, 0, 1, 1, 0, '2026-04-10 16:03:01', '2026-04-10 16:03:01', NULL),
(612, 627, 7, '25G063', NULL, '2028-07-31', 10700.00, 15000.00, 0, 1, 1, 0, '2026-04-10 16:05:02', '2026-04-10 16:05:02', NULL),
(613, 629, 7, 'KD/464', NULL, '2029-01-12', 182.00, 250.00, 0, 1, 0, 0, '2026-04-10 16:06:31', '2026-04-10 16:06:31', NULL),
(614, 628, 7, '25B215', NULL, '2028-02-29', 10700.00, 15000.00, 0, 1, 1, 0, '2026-04-10 16:06:40', '2026-04-10 16:06:40', NULL),
(615, 630, 7, 'E11801', NULL, '2027-09-30', 3850.00, 5400.00, 0, 1, 1, 0, '2026-04-10 16:10:24', '2026-04-12 14:38:41', NULL),
(616, 631, 7, '60825008', NULL, '2028-04-30', 1620.00, 2300.00, 0, 11, 1, 0, '2026-04-10 16:11:14', '2026-04-12 12:27:32', NULL),
(617, 632, 7, '241218', NULL, '2027-11-30', 1712.00, 2400.00, 0, 2, 1, 0, '2026-04-10 16:15:04', '2026-04-10 16:15:04', NULL),
(618, 633, 7, '202505006', '0050-02-02', '2028-06-30', 770.50, 1100.00, 0, 7, 2, 0, '2026-04-10 16:18:59', '2026-04-18 11:38:26', NULL),
(619, 634, 7, '6008121', NULL, '2029-03-12', 695.00, 1000.00, 0, 3, 1, 0, '2026-04-10 16:20:21', '2026-04-10 16:20:21', NULL),
(620, 635, 7, '202501002', NULL, '2028-01-31', 1112.80, 1600.00, 0, 10, 2, 0, '2026-04-10 16:22:54', '2026-04-10 16:22:54', NULL),
(621, 636, 7, '250505', NULL, '2028-05-12', 400.00, 600.00, 0, 9, 2, 0, '2026-04-10 16:24:30', '2026-04-18 15:24:21', NULL),
(622, 637, 7, 'M02240805', NULL, '2029-07-31', 267.50, 400.00, 0, 36, 10, 0, '2026-04-10 16:28:02', '2026-04-10 16:28:02', NULL),
(623, 639, 7, '130527', NULL, '2027-05-12', 1695.00, 2200.00, 0, 3, 1, 0, '2026-04-10 16:30:43', '2026-04-10 16:30:43', NULL),
(624, 638, 7, '202510010', NULL, '2028-10-31', 675.50, 950.00, 0, 10, 2, 0, '2026-04-10 16:30:53', '2026-04-10 16:30:53', NULL),
(625, 640, 7, '5112A', NULL, '2028-03-31', 10270.00, 14400.00, 0, 1, 1, 0, '2026-04-10 16:33:54', '2026-04-10 16:33:54', NULL),
(626, 641, 7, '417', NULL, '2028-04-12', 850.00, 1100.00, 0, 3, 1, 0, '2026-04-10 16:34:31', '2026-04-10 16:34:31', NULL),
(627, 642, 7, '5129A', NULL, '2029-03-31', 5050.00, 7100.00, 0, 1, 1, 0, '2026-04-10 16:35:41', '2026-04-10 16:35:41', NULL),
(628, 644, 7, 'KD395', NULL, '2028-02-12', 610.00, 850.00, 0, 5, 1, 0, '2026-04-10 16:39:05', '2026-04-10 16:39:05', NULL),
(629, 643, 7, '25J20o2', NULL, '2029-10-19', 3103.00, 4350.00, 0, 3, 3, 0, '2026-04-10 16:39:39', '2026-04-10 16:39:39', NULL),
(630, 646, 7, '32329E', NULL, '2028-11-12', 150.00, 200.00, 0, 10, 2, 0, '2026-04-10 16:42:18', '2026-04-10 16:42:18', NULL),
(631, 645, 7, 'ECSY0064', NULL, '2027-11-30', 10165.00, 14250.00, 0, 1, 1, 0, '2026-04-10 16:42:33', '2026-04-10 16:42:33', NULL),
(632, 648, 7, 'C102', NULL, '2028-05-12', 1125.00, 1600.00, 0, 5, 1, 0, '2026-04-10 16:45:55', '2026-04-10 16:45:55', NULL),
(633, 647, 7, '93H0127', NULL, '2027-01-31', 635.00, 900.00, 0, 2, 1, 0, '2026-04-10 16:46:51', '2026-04-10 16:46:51', NULL),
(634, 649, 7, '343156', NULL, '2030-05-31', 642.00, 900.00, 0, 3, 3, 0, '2026-04-10 16:49:40', '2026-04-10 16:49:40', NULL),
(635, 650, 7, 'PO261', NULL, '2027-08-12', 2410.00, 3400.00, 0, 4, 1, 0, '2026-04-10 16:50:19', '2026-04-10 16:50:19', NULL),
(636, 651, 7, 'C5824056', NULL, '2027-11-30', 675.00, 950.00, 0, 3, 2, 0, '2026-04-10 16:52:05', '2026-04-10 16:52:05', NULL),
(637, 652, 7, 'AC240003A', NULL, '2026-12-12', 3210.00, 4500.00, 0, 10, 5, 0, '2026-04-10 16:57:07', '2026-04-10 16:57:07', NULL),
(638, 653, 7, 'T23625', NULL, '2027-06-12', 550.00, 770.00, 0, 5, 1, 0, '2026-04-10 17:00:43', '2026-04-10 17:00:43', NULL),
(639, 654, 7, '4304A', NULL, '2028-08-12', 4600.00, 6450.00, 0, 2, 1, 0, '2026-04-10 17:05:22', '2026-04-10 17:05:22', NULL),
(640, 655, 7, 'C0225013', NULL, '2027-07-12', 375.00, 525.00, 0, 6, 2, 0, '2026-04-10 17:09:08', '2026-04-10 17:09:08', NULL),
(641, 656, 7, 'A250512', NULL, '2030-10-12', 155.00, 220.00, 0, 20, 10, 0, '2026-04-10 17:12:10', '2026-04-10 17:12:10', NULL),
(642, 657, 7, 'AR241108', NULL, '2027-10-31', 400.00, 600.00, 0, 20, 2, 0, '2026-04-10 17:16:03', '2026-04-18 14:06:51', NULL),
(643, 658, 7, 'M25G004', NULL, '2027-12-11', 2140.00, 3000.00, 0, 8, 2, 0, '2026-04-10 17:19:30', '2026-04-20 08:34:59', NULL),
(644, 659, 7, '1128', NULL, '2028-11-12', 11.45, 100.00, 0, 144, 40, 10, '2026-04-10 17:22:36', '2026-04-17 13:19:21', NULL),
(645, 600, 7, '344223', NULL, '2030-07-31', 345.68, 500.00, 0, 25, 0, 0, '2026-04-11 12:09:24', '2026-04-11 12:09:24', NULL),
(646, 240, 7, 'FPA150226', NULL, '2028-12-31', 598.00, 850.00, 0, 2, 0, 0, '2026-04-11 12:18:36', '2026-04-11 12:23:25', NULL),
(647, 660, 7, '20202719', NULL, '2028-09-30', 10698.00, 15000.00, 0, 1, 1, 0, '2026-04-11 12:36:11', '2026-04-11 12:36:11', NULL),
(648, 661, 7, 'PH07C0', NULL, '2027-02-06', 155.00, 250.00, 0, 10, 5, 0, '2026-04-11 12:39:33', '2026-04-11 12:39:33', NULL),
(649, 662, 7, 'NMA25001', NULL, '2027-12-31', 1747.67, 2450.00, 0, 3, 3, 0, '2026-04-11 12:43:50', '2026-04-11 12:43:50', NULL),
(650, 663, 7, 'L5252/3', NULL, '2028-09-30', 4655.00, 6550.00, 0, 1, 1, 0, '2026-04-11 12:47:20', '2026-04-11 12:47:20', NULL),
(651, 664, 7, 'IZM024061', NULL, '2027-07-12', 965.00, 1350.00, 0, 2, 1, 0, '2026-04-11 12:47:33', '2026-04-11 12:47:33', NULL),
(652, 665, 7, 'L5252/4', NULL, '2028-09-30', 4018.00, 5650.00, 0, 4, 1, 0, '2026-04-11 12:50:17', '2026-04-11 12:50:17', NULL),
(653, 666, 7, 'IZN0225001', NULL, '2027-12-12', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-11 12:50:45', '2026-04-11 12:50:45', NULL),
(654, 667, 7, '7406', NULL, '2027-11-30', 1171.00, 1650.00, 0, 3, 1, 0, '2026-04-11 12:54:46', '2026-04-11 12:54:46', NULL),
(655, 668, 7, 'JM0492', NULL, '2028-02-12', 15000.00, 21000.00, 0, 1, 0, 0, '2026-04-11 12:56:26', '2026-04-11 12:56:26', NULL),
(656, 669, 7, '3666E', NULL, '2030-12-04', 137.50, 200.00, 0, 160, 50, 0, '2026-04-11 13:02:50', '2026-04-11 13:02:50', NULL),
(657, 670, 7, 'LZ5098', NULL, '2028-03-31', 10165.00, 14250.00, 0, 1, 1, 0, '2026-04-11 13:04:06', '2026-04-11 13:04:06', NULL),
(658, 671, 7, '104F0229', NULL, '2029-05-12', 710.00, 1000.00, 0, 3, 1, 0, '2026-04-11 13:06:23', '2026-04-11 13:06:23', NULL),
(659, 672, 7, 'FW2402AA', NULL, '2027-10-31', 5136.00, 7200.00, 0, 2, 2, 0, '2026-04-11 13:08:10', '2026-04-11 13:08:10', NULL),
(660, 673, 7, '327828A', NULL, '2028-04-30', 11880.00, 16650.00, 0, 1, 1, 0, '2026-04-11 13:13:43', '2026-04-11 13:13:43', NULL),
(661, 674, 7, 'G251267', NULL, '2027-10-12', 1600.00, 2250.00, 0, 2, 1, 0, '2026-04-11 13:14:32', '2026-04-11 13:14:32', NULL),
(662, 675, 7, '175659', NULL, '2028-07-31', 12840.00, 18000.00, 0, 1, 1, 0, '2026-04-11 13:17:58', '2026-04-11 13:17:58', NULL),
(663, 676, 7, 'F4079', NULL, '2027-09-12', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-11 13:19:12', '2026-04-11 13:19:12', NULL),
(664, 677, 7, '173449', NULL, '2028-03-31', 13325.00, 18650.00, 0, 1, 1, 0, '2026-04-11 13:22:30', '2026-04-11 13:22:30', NULL),
(665, 680, 7, '25B047', NULL, '2028-01-12', 5350.00, 7500.00, 0, 2, 1, 0, '2026-04-11 14:32:16', '2026-04-11 14:32:16', NULL),
(666, 679, 7, 'WP2513', NULL, '2028-04-30', 20275.00, 28400.00, 0, 1, 1, 0, '2026-04-11 14:32:36', '2026-04-11 14:32:36', NULL),
(667, 681, 7, 'IE2503T', NULL, '2028-09-11', 20972.00, 29400.00, 0, 1, 1, 0, '2026-04-11 14:35:14', '2026-04-11 14:35:14', NULL),
(668, 682, 7, '499', NULL, '2030-04-12', 800.00, 1150.00, 0, 2, 1, 0, '2026-04-11 14:35:20', '2026-04-11 14:35:20', NULL),
(669, 683, 7, 'IEA2501P', NULL, '2028-07-31', 27606.00, 38650.00, 0, 1, 1, 0, '2026-04-11 14:38:11', '2026-04-11 14:38:11', NULL),
(670, 684, 7, 'L225264', NULL, '2028-09-22', 400.00, 560.00, 0, 2, 1, 0, '2026-04-11 14:39:59', '2026-04-11 14:39:59', NULL),
(671, 685, 7, 'L225026', NULL, '2028-01-12', 700.00, 980.00, 0, 2, 1, 0, '2026-04-11 14:42:20', '2026-04-11 14:42:20', NULL),
(672, 686, 7, '5313126220', NULL, '2028-09-30', 17120.00, 24000.00, 0, 1, 1, 0, '2026-04-11 14:43:30', '2026-04-11 14:43:30', NULL),
(673, 687, 7, 'L225228', NULL, '2028-08-12', 800.00, 1120.00, 0, 2, 1, 0, '2026-04-11 14:44:15', '2026-04-11 14:44:15', NULL),
(674, 688, 7, '25G065', NULL, '2028-07-31', 10700.00, 15000.00, 0, 1, 1, 0, '2026-04-11 14:45:58', '2026-04-11 14:45:58', NULL),
(675, 182, 7, '1225213', NULL, '2028-12-31', 12626.00, 17700.00, 0, 1, 1, 0, '2026-04-11 14:48:18', '2026-04-11 14:48:18', NULL),
(676, 689, 7, 'A09PT8', NULL, '2027-09-12', 6500.00, 9100.00, 0, 2, 1, 0, '2026-04-11 14:48:30', '2026-04-11 14:48:30', NULL),
(677, 690, 7, '0525072', NULL, '2028-05-31', 10379.00, 14550.00, 0, 1, 1, 0, '2026-04-11 14:51:45', '2026-04-11 14:51:45', NULL),
(678, 692, 7, '25285', NULL, '2028-09-12', 590.00, 850.00, 0, 5, 1, 0, '2026-04-11 14:54:29', '2026-04-11 14:54:29', NULL),
(679, 691, 7, '5M053002', NULL, '2028-05-31', 4495.00, 6300.00, 0, 2, 1, 0, '2026-04-11 14:54:59', '2026-04-11 14:54:59', NULL),
(680, 693, 7, 'D025052', NULL, '2028-10-12', 640.00, 900.00, 0, 3, 1, 0, '2026-04-11 14:58:40', '2026-04-11 14:58:40', NULL),
(681, 558, 7, 'KPS25110', NULL, '2028-08-31', 499.00, 700.00, 0, 4, 0, 0, '2026-04-11 14:59:21', '2026-04-11 14:59:21', NULL),
(682, 678, 7, '25147', NULL, '2028-05-12', 520.00, 750.00, 0, 3, 1, 0, '2026-04-11 15:01:04', '2026-04-11 15:01:04', NULL),
(683, 694, 7, '1030825', NULL, '2028-07-31', 749.00, 1050.00, 0, 3, 1, 0, '2026-04-11 15:03:00', '2026-04-11 15:03:00', NULL),
(684, 695, 7, '2506039', NULL, '2028-07-31', 7319.00, 10250.00, 0, 1, 1, 0, '2026-04-11 15:05:43', '2026-04-11 15:05:43', NULL),
(685, 697, 7, '25GP0148', NULL, '2028-06-12', 545.00, 800.00, 0, 5, 1, 0, '2026-04-11 15:08:50', '2026-04-11 15:08:50', NULL),
(686, 696, 7, '4146', NULL, '2029-01-31', 1871.25, 2650.00, 0, 4, 4, 0, '2026-04-11 15:10:42', '2026-04-11 15:10:42', NULL),
(687, 698, 7, '09H0429', NULL, '2029-07-12', 980.00, 1380.00, 0, 5, 1, 0, '2026-04-11 15:11:43', '2026-04-11 15:11:43', NULL),
(688, 699, 7, '25D212', NULL, '2028-01-31', 2833.33, 4000.00, 0, 3, 3, 0, '2026-04-11 15:14:27', '2026-04-11 15:14:27', NULL),
(689, 700, 7, 'I417E5001', NULL, '2028-02-12', 2785.00, 3900.00, 0, 5, 1, 0, '2026-04-11 15:15:36', '2026-04-11 15:15:36', NULL),
(690, 701, 7, 'M24L003', NULL, '2027-11-30', 6153.00, 8650.00, 0, 1, 1, 0, '2026-04-11 15:17:30', '2026-04-11 15:17:30', NULL),
(691, 702, 7, 'M24L002', NULL, '2027-11-30', 7383.00, 10350.00, 0, 1, 1, 0, '2026-04-11 15:20:05', '2026-04-11 15:20:05', NULL),
(692, 703, 7, 'KP25036', NULL, '2028-10-12', 113.50, 160.00, 0, 10, 2, 0, '2026-04-11 15:20:17', '2026-04-11 15:20:17', NULL),
(693, 704, 7, '61125006', NULL, '2028-02-12', 2900.00, 4060.00, 0, 2, 1, 0, '2026-04-11 15:23:17', '2026-04-11 15:23:17', NULL),
(694, 706, 7, '5289A', NULL, '2028-08-12', 2460.00, 3450.00, 0, 2, 1, 0, '2026-04-11 15:26:48', '2026-04-11 15:26:48', NULL),
(695, 705, 7, '25G11E1', NULL, '2027-07-10', 2996.00, 4200.00, 0, 3, 3, 0, '2026-04-11 15:28:01', '2026-04-11 15:28:01', NULL),
(696, 707, 7, '46B0529', NULL, '2029-01-12', 1020.00, 1450.00, 0, 2, 1, 0, '2026-04-11 15:29:29', '2026-04-11 15:29:29', NULL),
(697, 708, 7, '25F07C1', NULL, '2027-06-06', 3174.33, 4450.00, 0, 3, 3, 0, '2026-04-11 15:32:55', '2026-04-11 15:32:55', NULL),
(698, 709, 7, '55010048', NULL, '2028-04-30', 185.00, 300.00, 0, 5, 1, 0, '2026-04-11 15:37:08', '2026-04-11 15:37:08', NULL),
(699, 710, 7, '5130506', NULL, '2028-05-11', 1602.00, 2250.00, 0, 2, 1, 0, '2026-04-11 15:41:58', '2026-04-11 15:41:58', NULL),
(700, 711, 7, 'A250379', NULL, '2028-07-12', 480.00, 700.00, 0, 3, 1, 0, '2026-04-11 15:43:23', '2026-04-11 15:43:23', NULL),
(701, 712, 7, '2504034A', NULL, '2028-03-31', 3317.00, 4650.00, 0, 2, 1, 0, '2026-04-11 15:44:41', '2026-04-20 12:36:35', NULL),
(702, 713, 7, '25319', NULL, '2028-10-12', 645.00, 900.00, 0, 3, 1, 0, '2026-04-11 15:47:22', '2026-04-11 15:47:22', NULL),
(703, 714, 7, 'M25D013', NULL, '2028-03-31', 808.33, 1150.00, 0, 6, 3, 0, '2026-04-11 15:50:10', '2026-04-11 15:50:10', NULL),
(704, 715, 7, 'B251731', NULL, '2030-07-12', 133.75, 200.00, 0, 200, 5, 0, '2026-04-11 15:50:54', '2026-04-11 15:50:54', NULL),
(705, 676, 7, 'F4078', NULL, '2027-09-11', 1100.00, 1550.00, 0, 1, 0, 0, '2026-04-11 15:54:28', '2026-04-11 15:54:28', NULL),
(706, 716, 7, 'FD24144', NULL, '2027-06-12', 500.00, 700.00, 0, 10, 2, 0, '2026-04-11 15:58:11', '2026-04-11 15:58:11', NULL),
(707, 717, 7, 'SD0052', NULL, '2028-01-31', 2942.50, 4150.00, 0, 6, 6, 0, '2026-04-11 16:01:04', '2026-04-11 16:01:04', NULL),
(708, 718, 7, 'C0126001', NULL, '2027-12-12', 1070.00, 1500.00, 0, 4, 1, 0, '2026-04-11 16:02:46', '2026-04-20 13:03:54', NULL),
(709, 719, 7, '150953', NULL, '2028-09-30', 299.80, 450.00, 0, 20, 10, 0, '2026-04-11 16:06:21', '2026-04-11 16:06:21', NULL),
(710, 720, 7, '04K0129', NULL, '2029-09-12', 880.00, 1250.00, 0, 6, 1, 0, '2026-04-11 16:07:25', '2026-04-11 16:07:25', NULL),
(711, 721, 7, 'F2725008', NULL, '2027-07-31', 749.00, 1050.00, 0, 1, 1, 0, '2026-04-11 16:20:26', '2026-04-11 16:20:26', NULL),
(712, 722, 7, '05G0229', NULL, '2029-06-12', 1620.00, 2300.00, 0, 5, 1, 0, '2026-04-11 16:21:15', '2026-04-11 16:21:15', NULL),
(713, 724, 7, '18G0129', NULL, '2029-06-30', 1685.00, 2400.00, 0, 3, 1, 0, '2026-04-11 16:24:45', '2026-04-18 16:04:41', NULL),
(714, 723, 7, '250236', NULL, '2028-02-29', 121.00, 200.00, 0, 10, 2, 0, '2026-04-11 16:25:02', '2026-04-11 16:25:02', NULL),
(715, 176, 7, 'T66207', NULL, '2028-01-31', 332.90, 500.00, 0, 10, 0, 0, '2026-04-11 16:27:03', '2026-04-11 16:27:03', NULL),
(716, 725, 7, '12M0129', NULL, '2029-11-04', 2700.00, 3800.00, 0, 2, 1, 0, '2026-04-11 16:28:39', '2026-04-11 16:28:39', NULL),
(717, 275, 7, 'MP2602', NULL, '2029-01-31', 460.00, 650.00, 0, 2, 0, 0, '2026-04-11 16:30:12', '2026-04-11 16:30:12', NULL),
(718, 128, 7, '38', NULL, '2028-02-29', 3300.00, 4650.00, 0, 1, 0, 0, '2026-04-11 16:32:13', '2026-04-11 16:32:13', NULL),
(719, 726, 7, '103G0729', NULL, '2029-06-12', 1180.00, 1650.00, 0, 2, 1, 0, '2026-04-11 16:32:16', '2026-04-11 16:32:16', NULL),
(720, 270, 7, '25286', NULL, '2028-09-30', 717.00, 1050.00, 0, 1, 0, 0, '2026-04-11 16:34:55', '2026-04-11 16:34:55', NULL),
(721, 417, 7, 'E216788', NULL, '2029-03-31', 2043.00, 2900.00, 0, 2, 0, 0, '2026-04-11 16:38:42', '2026-04-11 16:38:42', NULL),
(722, 727, 7, 'MSNUH0003', NULL, '2028-04-30', 1248.33, 1750.00, 0, 3, 3, 0, '2026-04-11 16:46:27', '2026-04-11 16:46:27', NULL),
(723, 160, 7, 'TR147', NULL, '2028-06-30', 2309.00, 3250.00, 0, 6, 0, 0, '2026-04-11 16:48:22', '2026-04-11 16:48:22', NULL),
(724, 161, 7, 'TR086', NULL, '2028-07-31', 2309.00, 3250.00, 0, 6, 0, 0, '2026-04-11 16:49:35', '2026-04-11 16:49:35', NULL),
(725, 728, 7, 'GC25057', NULL, '2028-04-12', 3505.00, 4900.00, 0, 3, 1, 0, '2026-04-11 16:55:24', '2026-04-11 16:55:24', NULL),
(726, 729, 7, '11M0329', NULL, '2029-11-04', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-11 17:01:02', '2026-04-11 17:01:02', NULL),
(727, 730, 7, '11K0229', NULL, '2029-09-12', 2150.00, 3050.00, 0, 2, 1, 0, '2026-04-12 07:49:26', '2026-04-12 07:49:26', NULL),
(728, 169, 7, 'N-3533', NULL, '2028-11-30', 821.43, 1150.00, 0, 8, 0, 0, '2026-04-12 07:51:18', '2026-04-12 07:51:18', NULL),
(729, 731, 7, 'GC25054', NULL, '2028-04-12', 2666.60, 3750.00, 0, 3, 1, 0, '2026-04-12 07:57:01', '2026-04-12 07:57:01', NULL),
(730, 732, 7, '50125', NULL, '2028-06-12', 760.00, 1050.00, 0, 2, 1, 0, '2026-04-12 07:59:55', '2026-04-12 07:59:55', NULL),
(731, 733, 7, 'QAB0900', NULL, '2027-12-11', 4480.00, 6300.00, 0, 2, 0, 0, '2026-04-12 08:03:28', '2026-04-12 13:40:21', NULL),
(732, 734, 7, '32T24', NULL, '2029-10-31', 1662.00, 2350.00, 0, 2, 1, 0, '2026-04-12 08:05:12', '2026-04-12 08:05:12', NULL),
(733, 735, 7, 'I286E5020', NULL, '2028-07-12', 781.60, 1100.00, 0, 6, 1, 0, '2026-04-12 08:08:08', '2026-04-12 08:08:08', NULL),
(734, 736, 7, '250308', NULL, '2028-03-31', 188.90, 300.00, 0, 10, 3, 0, '2026-04-12 08:10:42', '2026-04-12 08:10:42', NULL),
(735, 737, 7, 'MHQH0021', NULL, '2027-05-31', 4377.00, 6150.00, 0, 1, 1, 0, '2026-04-12 08:14:36', '2026-04-12 08:14:36', NULL),
(736, 738, 7, '25274', NULL, '2028-09-09', 1550.00, 2200.00, 0, 5, 1, 0, '2026-04-12 08:15:48', '2026-04-12 08:15:48', NULL),
(737, 740, 7, '510N', NULL, '2028-11-12', 1285.00, 1800.00, 0, 3, 1, 0, '2026-04-12 08:18:08', '2026-04-12 08:18:08', NULL),
(738, 739, 7, '280T16', NULL, '2028-07-12', 1123.50, 1600.00, 0, 4, 4, 0, '2026-04-12 08:19:51', '2026-04-12 08:19:51', NULL),
(739, 741, 7, '2508001', NULL, '2028-07-12', 1740.00, 2450.00, 0, 5, 1, 0, '2026-04-12 08:21:47', '2026-04-12 08:21:47', NULL),
(740, 742, 7, '364F13', NULL, '2028-06-30', 1391.00, 1950.00, 0, 4, 4, 0, '2026-04-12 08:23:56', '2026-04-12 08:23:56', NULL),
(741, 744, 7, 'OMWH0104', NULL, '2028-06-12', 610.00, 850.00, 0, 3, 1, 0, '2026-04-12 08:29:04', '2026-04-12 08:29:04', NULL),
(742, 743, 7, 'C2-44', NULL, '2028-02-29', 1066.67, 1500.00, 0, 3, 3, 0, '2026-04-12 08:29:46', '2026-04-12 08:29:46', NULL),
(743, 745, 7, '25GP0166', NULL, '2028-06-12', 355.00, 500.00, 0, 5, 1, 0, '2026-04-12 08:33:22', '2026-04-12 08:33:22', NULL),
(744, 268, 7, 'NOA7004', NULL, '2028-01-17', 2565.00, 3600.00, 0, 2, 0, 0, '2026-04-12 08:33:23', '2026-04-12 08:33:23', NULL),
(745, 747, 7, 'D1AW032', NULL, '2027-07-31', 1405.00, 2000.00, 0, 15, 2, 0, '2026-04-12 08:37:04', '2026-04-12 12:39:51', NULL),
(746, 746, 7, 'T25048', NULL, '2028-06-30', 2639.33, 3700.00, 0, 3, 3, 0, '2026-04-12 08:37:27', '2026-04-12 08:37:27', NULL),
(747, 748, 7, 'A250444', NULL, '2028-09-12', 450.00, 650.00, 0, 10, 2, 0, '2026-04-12 08:40:35', '2026-04-12 08:40:35', NULL),
(748, 749, 7, '25227', NULL, '2027-07-12', 635.00, 900.00, 0, 5, 1, 0, '2026-04-12 08:43:12', '2026-04-12 08:43:12', NULL),
(749, 750, 7, '251120', NULL, '2028-11-20', 8100.00, 11350.00, 0, 1, 0, 0, '2026-04-12 08:46:55', '2026-04-12 08:46:55', NULL),
(750, 751, 7, '5H514003', NULL, '2028-07-12', 800.00, 1150.00, 0, 10, 1, 0, '2026-04-12 08:49:45', '2026-04-12 08:49:45', NULL),
(751, 752, 7, '26004', NULL, '2028-12-31', 1393.33, 2000.00, 0, 3, 3, 0, '2026-04-12 08:50:19', '2026-04-12 08:50:19', NULL),
(752, 753, 7, '5F508009', NULL, '2027-05-12', 900.00, 1250.00, 0, 5, 1, 0, '2026-04-12 08:53:17', '2026-04-12 08:53:17', NULL),
(753, 754, 7, '06K0129', NULL, '2029-09-30', 589.00, 850.00, 0, 2, 1, 0, '2026-04-12 08:55:58', '2026-04-12 08:55:58', NULL),
(754, 755, 7, '5K452025', NULL, '2027-09-12', 900.00, 1250.00, 0, 5, 1, 0, '2026-04-12 08:56:33', '2026-04-12 08:56:33', NULL),
(755, 756, 7, 'PCF2643', NULL, '2029-02-12', 480.00, 700.00, 0, 6, 1, 0, '2026-04-12 09:01:11', '2026-04-12 09:01:11', NULL),
(756, 246, 7, 'F2226', NULL, '2029-01-31', 428.00, 600.00, 0, 6, 0, 0, '2026-04-12 09:06:52', '2026-04-12 09:06:52', NULL),
(757, 757, 7, '100845', NULL, '2028-03-12', 2100.00, 3000.00, 0, 5, 1, 0, '2026-04-12 09:07:13', '2026-04-12 09:07:13', NULL),
(758, 758, 7, 'ENL002', NULL, '2028-12-31', 5136.00, 7200.00, 0, 1, 1, 0, '2026-04-12 09:12:12', '2026-04-12 09:12:12', NULL),
(759, 759, 7, '250701001', NULL, '2028-08-12', 58.00, 100.00, 0, 48, 2, 0, '2026-04-12 09:12:56', '2026-04-18 17:38:49', NULL),
(760, 760, 7, 'ENG035', NULL, '2028-07-31', 4066.00, 5700.00, 0, 1, 1, 0, '2026-04-12 09:16:12', '2026-04-12 09:16:12', NULL),
(761, 761, 7, 'GC25040', NULL, '2028-03-31', 2477.50, 3500.00, 0, 2, 2, 0, '2026-04-12 09:21:40', '2026-04-12 09:21:40', NULL),
(762, 762, 7, 'GDZ1025006', NULL, '2028-05-31', 2585.00, 3650.00, 0, 2, 2, 0, '2026-04-12 09:25:57', '2026-04-12 09:25:57', NULL),
(763, 763, 7, 'GDY1225003', NULL, '2028-05-31', 2407.50, 3400.00, 0, 2, 2, 0, '2026-04-12 09:29:51', '2026-04-12 09:29:51', NULL),
(764, 764, 7, '25E1822', NULL, '2028-05-31', 4387.00, 6150.00, 0, 3, 3, 0, '2026-04-12 09:36:11', '2026-04-12 09:36:11', NULL),
(765, 765, 7, '25006', NULL, '2027-09-30', 3208.33, 4500.00, 0, 3, 3, 0, '2026-04-12 09:43:32', '2026-04-12 09:43:32', NULL),
(766, 766, 7, '25006', NULL, '2027-09-30', 3208.33, 4500.00, 0, 3, 3, 0, '2026-04-12 09:46:40', '2026-04-12 09:46:40', NULL),
(767, 767, 7, '25J1780', NULL, '2027-10-31', 3370.50, 4750.00, 0, 4, 4, 0, '2026-04-12 09:55:04', '2026-04-12 09:55:04', NULL),
(768, 768, 7, '25I0773', NULL, '2027-09-30', 3410.75, 4800.00, 0, 4, 4, 0, '2026-04-12 09:58:31', '2026-04-12 09:58:31', NULL),
(769, 769, 7, 'NW25B13', NULL, '2029-01-31', 76.40, 150.00, 0, 50, 10, 0, '2026-04-12 10:04:44', '2026-04-12 10:04:44', NULL),
(770, 770, 7, '01M0229', NULL, '2029-11-10', 575.00, 800.00, 0, 5, 1, 0, '2026-04-12 10:08:31', '2026-04-12 10:08:31', NULL),
(771, 771, 7, 'XDAH0031', NULL, '2028-05-31', 1485.00, 2100.00, 0, 1, 1, 0, '2026-04-12 10:09:51', '2026-04-12 10:09:51', NULL),
(772, 772, 7, 'XDBH0039', NULL, '2028-02-29', 2345.00, 3300.00, 0, 1, 1, 0, '2026-04-12 10:14:01', '2026-04-12 10:14:01', NULL),
(773, 773, 7, 'E11801', NULL, '2027-09-12', 3745.00, 5250.00, 0, 2, 0, 0, '2026-04-12 10:16:39', '2026-04-12 14:40:49', NULL),
(774, 774, 7, '856E2', NULL, '2028-11-01', 5800.00, 8150.00, 0, 2, 1, 0, '2026-04-12 10:20:25', '2026-04-12 10:20:25', NULL),
(775, 775, 7, 'GT24475', NULL, '2027-07-12', 645.00, 950.00, 0, 10, 2, 0, '2026-04-12 10:20:42', '2026-04-12 10:20:42', NULL),
(776, 776, 7, 'L6126', NULL, '2028-01-31', 1750.00, 2450.00, 0, 5, 2, 0, '2026-04-12 10:26:52', '2026-04-12 10:26:52', NULL),
(777, 777, 7, 'AF60507', NULL, '2028-02-12', 790.00, 1100.00, 0, 10, 2, 0, '2026-04-12 10:27:43', '2026-04-12 10:27:43', NULL),
(778, 778, 7, '01260', NULL, '2030-02-28', 4387.00, 6150.00, 0, 2, 1, 0, '2026-04-12 10:31:59', '2026-04-12 10:31:59', NULL),
(779, 780, 7, 'L225059', NULL, '2028-02-12', 1177.50, 1650.00, 0, 4, 1, 0, '2026-04-12 10:34:48', '2026-04-12 10:34:48', NULL),
(780, 781, 7, 'F0225128', NULL, '2028-10-31', 562.00, 800.00, 0, 2, 1, 0, '2026-04-12 10:35:44', '2026-04-12 10:35:44', NULL),
(781, 782, 7, 'F01251088', NULL, '2028-11-30', 562.00, 800.00, 0, 3, 1, 0, '2026-04-12 10:39:21', '2026-04-12 10:39:21', NULL),
(782, 783, 7, 'UTGRBA501', NULL, '2028-02-02', 815.00, 1150.00, 0, 5, 1, 0, '2026-04-12 10:40:04', '2026-04-12 10:40:04', NULL),
(783, 784, 7, 'F0426042', NULL, '2028-12-31', 562.00, 800.00, 0, 3, 1, 0, '2026-04-12 10:42:57', '2026-04-12 10:42:57', NULL),
(784, 785, 7, '25G001DH26', NULL, '2027-06-12', 650.00, 950.00, 0, 6, 1, 0, '2026-04-12 10:43:33', '2026-04-12 10:43:33', NULL),
(785, 786, 7, 'AE20467', NULL, '2029-01-31', 850.00, 1250.00, 0, 4, 2, 0, '2026-04-12 10:47:12', '2026-04-12 10:47:12', NULL),
(786, 787, 7, 'OMZ165', NULL, '2028-07-12', 1600.00, 2250.00, 0, 1, 0, 0, '2026-04-12 10:47:25', '2026-04-12 10:47:25', NULL),
(787, 788, 7, '1200', NULL, '2030-12-31', 805.00, 1150.00, 0, 2, 1, 0, '2026-04-12 10:50:53', '2026-04-12 10:50:53', NULL),
(788, 789, 7, 'L223081', NULL, '2028-05-12', 535.00, 750.00, 0, 10, 2, 0, '2026-04-12 10:51:24', '2026-04-12 10:51:24', NULL),
(789, 790, 7, '1200', NULL, '2030-12-31', 1182.00, 1700.00, 0, 3, 1, 0, '2026-04-12 10:54:22', '2026-04-12 10:54:22', NULL),
(790, 791, 7, 'M0225047', NULL, '2028-07-12', 1340.00, 1900.00, 0, 2, 1, 0, '2026-04-12 10:54:36', '2026-04-12 10:54:36', NULL),
(791, 793, 7, 'CE06572', NULL, '2027-07-12', 800.00, 1150.00, 0, 10, 2, 0, '2026-04-12 10:57:46', '2026-04-12 10:57:46', NULL),
(792, 792, 7, '1200', NULL, '2030-12-31', 176.00, 250.00, 0, 10, 2, 0, '2026-04-12 10:58:44', '2026-04-12 10:58:44', NULL),
(793, 794, 7, 'CE05616', NULL, '2027-04-12', 378.50, 550.00, 0, 10, 2, 0, '2026-04-12 11:00:24', '2026-04-12 11:00:24', NULL),
(794, 795, 7, 'CF03594', NULL, '2028-02-29', 460.00, 650.00, 0, 10, 2, 0, '2026-04-12 11:05:18', '2026-04-12 11:05:18', NULL),
(795, 796, 7, 'CE10592', NULL, '2027-09-12', 885.00, 1300.00, 0, 10, 2, 0, '2026-04-12 11:05:55', '2026-04-12 11:05:55', NULL),
(796, 798, 7, 'CE05540', NULL, '2027-04-12', 448.00, 650.00, 0, 10, 2, 0, '2026-04-12 11:09:23', '2026-04-12 11:09:23', NULL),
(797, 797, 7, 'C2507003', NULL, '2028-06-30', 6265.00, 8800.00, 0, 1, 1, 0, '2026-04-12 11:09:25', '2026-04-12 11:09:25', NULL),
(798, 799, 7, '2237', NULL, '2028-09-12', 60.00, 100.00, 0, 40, 10, 0, '2026-04-12 11:14:14', '2026-04-12 11:14:14', NULL),
(799, 800, 7, 'CM24250', NULL, '2027-11-10', 660.00, 950.00, 0, 4, 1, 0, '2026-04-12 11:17:52', '2026-04-18 08:54:33', NULL),
(800, 801, 7, 'M25I012', NULL, '2028-02-29', 1495.00, 2100.00, 0, 0, 3, 0, '2026-04-12 11:19:18', '2026-04-18 11:35:48', NULL),
(801, 802, 7, '03M0129', NULL, '2029-11-12', 645.00, 900.00, 0, 5, 1, 0, '2026-04-12 11:20:47', '2026-04-12 11:20:47', NULL),
(802, 804, 7, '518W', NULL, '2028-10-12', 1930.00, 2700.00, 0, 3, 1, 0, '2026-04-12 11:25:24', '2026-04-12 11:25:24', NULL);
INSERT INTO `stock_items` (`id`, `drug_id`, `branch_id`, `batch_number`, `manufacturing_date`, `expiry_date`, `purchase_price`, `selling_price`, `vat_applicable`, `quantity_available`, `minimum_stock_level`, `reorder_point`, `created_at`, `updated_at`, `deleted_at`) VALUES
(803, 803, 7, 'S25E068', NULL, '2027-08-30', 1460.00, 2100.00, 0, 3, 1, 0, '2026-04-12 11:25:29', '2026-04-18 14:09:44', NULL),
(804, 806, 7, 'BYT072D', NULL, '2028-07-12', 1050.00, 1500.00, 0, 1, 0, 0, '2026-04-12 11:30:11', '2026-04-12 11:30:11', NULL),
(805, 805, 7, '502299004A', NULL, '2027-07-31', 690.00, 1000.00, 0, 5, 5, 0, '2026-04-12 11:30:22', '2026-04-12 11:30:22', NULL),
(806, 807, 7, '111336', NULL, '2028-07-12', 3480.00, 4900.00, 0, 2, 1, 0, '2026-04-12 11:34:00', '2026-04-12 11:34:00', NULL),
(807, 808, 7, 'DRP2825001', NULL, '2028-02-12', 1280.00, 1800.00, 0, 5, 2, 0, '2026-04-12 11:34:42', '2026-04-12 11:34:42', NULL),
(808, 809, 7, 'AS251002', NULL, '2028-09-30', 1310.00, 1850.00, 0, 2, 1, 0, '2026-04-12 11:40:11', '2026-04-12 11:40:11', NULL),
(809, 810, 7, 'DRD004L', NULL, '2027-06-12', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-12 11:43:50', '2026-04-12 11:43:50', NULL),
(810, 811, 7, '346437', NULL, '2027-05-31', 4375.00, 6150.00, 0, 2, 1, 0, '2026-04-12 11:44:09', '2026-04-12 11:44:09', NULL),
(811, 637, 7, 'M01240701', NULL, '2029-06-01', 285.00, 400.00, 0, 35, 0, 0, '2026-04-12 11:46:49', '2026-04-18 09:03:10', NULL),
(812, 812, 7, 'FORCEPT141', NULL, '2028-12-12', 4000.00, 5600.00, 0, 1, 0, 0, '2026-04-12 11:47:09', '2026-04-12 11:47:09', NULL),
(813, 813, 7, '24N0186', NULL, '2028-12-31', 360.00, 500.00, 0, 24, 5, 0, '2026-04-12 11:54:45', '2026-04-12 11:54:45', NULL),
(814, 814, 7, '25I30E1', NULL, '2027-09-12', 2716.60, 3800.00, 0, 2, 1, 0, '2026-04-12 11:57:56', '2026-04-20 12:37:59', NULL),
(815, 815, 7, '371024', NULL, '2027-09-30', 1050.00, 1500.00, 0, 3, 1, 0, '2026-04-12 11:59:42', '2026-04-12 11:59:42', NULL),
(816, 816, 7, '011T425', NULL, '2028-06-30', 595.00, 850.00, 0, 4, 2, 0, '2026-04-12 12:04:02', '2026-04-12 12:04:02', NULL),
(817, 818, 7, 'W12508', NULL, '2028-09-12', 1230.00, 1750.00, 0, 1, 1, 0, '2026-04-12 12:05:18', '2026-04-12 12:16:30', NULL),
(818, 817, 7, 'W12508', NULL, '2028-09-30', 1750.00, 2450.00, 0, 3, 1, 0, '2026-04-12 12:07:17', '2026-04-18 15:25:52', NULL),
(819, 819, 7, '1003080965', NULL, '2030-05-31', 9765.00, 13700.00, 0, 2, 1, 0, '2026-04-12 12:10:40', '2026-04-12 12:10:40', NULL),
(820, 820, 7, '31214488', NULL, '2027-06-03', 19440.00, 27250.00, 0, 1, 1, 0, '2026-04-12 12:17:46', '2026-04-12 12:17:46', NULL),
(821, 821, 7, '1456E', NULL, '2028-05-31', 2.16, 10.00, 0, 1000, 50, 0, '2026-04-12 12:23:11', '2026-04-12 12:23:11', NULL),
(822, 822, 7, 'J0124', NULL, '2027-11-10', 7000.00, 9800.00, 0, 1, 0, 0, '2026-04-12 12:30:01', '2026-04-12 12:30:01', NULL),
(823, 823, 7, '25/27/2001', NULL, '2028-06-30', 11560.00, 16200.00, 0, 1, 1, 0, '2026-04-12 12:34:18', '2026-04-12 12:34:18', NULL),
(824, 824, 7, 'TD24K421-B0R', NULL, '2027-02-01', 4490.00, 6300.00, 0, 2, 0, 0, '2026-04-12 12:37:12', '2026-04-17 13:17:51', NULL),
(825, 825, 7, 'SKO0145', NULL, '2028-03-31', 1800.00, 2550.00, 0, 4, 1, 0, '2026-04-12 12:41:21', '2026-04-18 13:31:15', NULL),
(826, 826, 7, '1002898657', NULL, '2030-01-31', 9765.00, 13700.00, 0, 2, 1, 0, '2026-04-12 12:44:00', '2026-04-12 12:44:00', NULL),
(827, 827, 7, 'L225078', NULL, '2030-03-12', 48.30, 100.00, 0, 30, 10, 0, '2026-04-12 12:46:39', '2026-04-12 12:46:39', NULL),
(828, 828, 7, 'CZ2233H3', NULL, '2027-08-01', 6430.00, 9000.00, 0, 6, 1, 0, '2026-04-12 12:47:47', '2026-04-12 12:47:47', NULL),
(829, 829, 7, '121206A01CE', NULL, '2028-06-30', 1190.00, 1700.00, 0, 2, 1, 0, '2026-04-12 12:51:58', '2026-04-12 12:51:58', NULL),
(830, 830, 7, '9344CBZ', NULL, '2027-03-12', 1240.00, 1800.00, 0, 10, 2, 0, '2026-04-12 12:52:50', '2026-04-12 12:52:50', NULL),
(831, 831, 7, 'P211025', NULL, '2027-10-21', 4430.00, 6200.00, 0, 1, 1, 0, '2026-04-12 12:55:30', '2026-04-20 08:34:59', NULL),
(832, 832, 7, '251024JA', NULL, '2028-01-12', 8030.00, 11250.00, 0, 2, 1, 0, '2026-04-12 12:57:00', '2026-04-12 12:57:00', NULL),
(833, 415, 7, 'CF06603', NULL, '2028-05-12', 650.00, 900.00, 0, 10, 2, 0, '2026-04-12 12:59:07', '2026-04-12 12:59:07', NULL),
(834, 833, 7, 'TT5231Z', NULL, '2028-08-01', 6375.00, 8950.00, 0, 6, 1, 0, '2026-04-12 12:59:27', '2026-04-12 12:59:27', NULL),
(835, 834, 7, 'BTMT0126', NULL, '2028-03-12', 5140.00, 7200.00, 0, 1, 0, 0, '2026-04-12 13:02:36', '2026-04-12 13:02:36', NULL),
(836, 835, 7, '1002624005', NULL, '2028-07-31', 5195.00, 7300.00, 0, 2, 1, 0, '2026-04-12 13:03:21', '2026-04-12 13:03:21', NULL),
(837, 836, 7, 'KT4222530', NULL, '2029-07-01', 6050.00, 8500.00, 0, 6, 1, 0, '2026-04-12 13:06:37', '2026-04-12 13:06:37', NULL),
(838, 837, 7, '2508128', NULL, '2028-10-20', 26380.00, 37000.00, 0, 1, 0, 0, '2026-04-12 13:09:42', '2026-04-12 13:09:42', NULL),
(839, 838, 7, 'L503D', NULL, '2027-10-31', 650.00, 950.00, 0, 3, 1, 0, '2026-04-12 13:10:53', '2026-04-12 13:10:53', NULL),
(840, 839, 7, '30808J', NULL, '2028-07-12', 11200.00, 15700.00, 0, 1, 0, 0, '2026-04-12 13:12:27', '2026-04-12 13:12:27', NULL),
(841, 840, 7, '2WM2890KA592', NULL, '2028-12-31', 11560.00, 16200.00, 0, 1, 1, 0, '2026-04-12 13:16:55', '2026-04-12 13:16:55', NULL),
(842, 841, 7, '25D21F1', NULL, '2029-04-12', 3243.30, 4550.00, 0, 3, 1, 0, '2026-04-12 13:17:27', '2026-04-12 13:17:27', NULL),
(843, 842, 7, '34', NULL, '2027-07-15', 2340.00, 3300.00, 0, 12, 2, 0, '2026-04-12 13:20:36', '2026-04-12 13:20:36', NULL),
(844, 843, 7, 'NR02217A', NULL, '2027-07-12', 4100.00, 5750.00, 0, 5, 1, 0, '2026-04-12 13:22:17', '2026-04-12 13:22:17', NULL),
(845, 844, 7, '5101450', NULL, '2027-08-31', 9948.84, 13950.00, 1, 2, 1, 0, '2026-04-12 13:25:16', '2026-04-12 13:38:14', NULL),
(846, 845, 7, '41T12', NULL, '2027-10-12', 1100.00, 1550.00, 0, 2, 1, 0, '2026-04-12 13:27:03', '2026-04-12 13:27:03', NULL),
(847, 846, 7, '1002714913', NULL, '2029-10-31', 3745.00, 5250.00, 0, 2, 1, 0, '2026-04-12 13:28:12', '2026-04-12 13:28:12', NULL),
(848, 847, 7, '23F2514', NULL, '2028-10-31', 2890.00, 4050.00, 0, 2, 1, 0, '2026-04-12 13:31:19', '2026-04-12 13:31:19', NULL),
(849, 731, 7, 'GC25049', NULL, '2028-04-20', 2833.30, 4000.00, 0, 3, 1, 0, '2026-04-12 13:36:02', '2026-04-12 13:36:02', NULL),
(850, 848, 7, '1002539827', NULL, '2029-06-30', 4305.00, 6050.00, 0, 2, 1, 0, '2026-04-12 13:43:40', '2026-04-12 13:43:40', NULL),
(851, 849, 7, '1293197', NULL, '2027-11-12', 6120.00, 8600.00, 0, 2, 0, 0, '2026-04-12 13:44:26', '2026-04-12 13:44:26', NULL),
(852, 850, 7, '1002705196', NULL, '2029-09-30', 3655.00, 5150.00, 0, 2, 1, 0, '2026-04-12 13:46:17', '2026-04-12 13:46:17', NULL),
(853, 851, 7, 'M50909', NULL, '2027-08-02', 1440.00, 2050.00, 0, 2, 1, 0, '2026-04-12 13:48:06', '2026-04-12 13:48:06', NULL),
(854, 852, 7, 'WG24590', NULL, '2028-08-31', 380.00, 550.00, 0, 3, 1, 0, '2026-04-12 13:50:34', '2026-04-12 13:50:34', NULL),
(855, 853, 7, 'ECSY0065', NULL, '2028-01-12', 10170.00, 14250.00, 0, 2, 1, 0, '2026-04-12 13:52:15', '2026-04-12 13:52:15', NULL),
(856, 854, 7, 'BABAF', NULL, '2027-09-30', 7020.00, 9850.00, 0, 1, 1, 0, '2026-04-12 13:54:06', '2026-04-12 13:54:06', NULL),
(857, 855, 7, 'ED826', NULL, '2027-02-12', 10080.00, 14150.00, 0, 2, 1, 0, '2026-04-12 13:55:09', '2026-04-12 13:55:09', NULL),
(858, 856, 7, '027T433', NULL, '2028-11-30', 2270.00, 3200.00, 0, 2, 2, 0, '2026-04-12 13:58:22', '2026-04-12 13:58:22', NULL),
(859, 857, 7, 'BL4003', NULL, '2027-03-12', 500.00, 700.00, 0, 10, 2, 0, '2026-04-12 13:58:47', '2026-04-12 13:58:47', NULL),
(860, 607, 7, '25K002DH42', NULL, '2027-09-30', 620.00, 900.00, 0, 3, 0, 0, '2026-04-12 14:02:01', '2026-04-12 14:02:01', NULL),
(861, 858, 7, 'VE8T', NULL, '2027-10-12', 5175.00, 7250.00, 0, 2, 1, 0, '2026-04-12 14:02:39', '2026-04-12 14:02:39', NULL),
(862, 859, 7, '1250801', NULL, '2028-08-31', 650.00, 950.00, 0, 6, 2, 0, '2026-04-12 14:05:49', '2026-04-12 14:05:49', NULL),
(863, 860, 7, 'A433', NULL, '2028-01-12', 2300.00, 3250.00, 0, 1, 0, 0, '2026-04-12 14:05:55', '2026-04-12 14:05:55', NULL),
(864, 861, 7, 'WE167S', NULL, '2030-03-10', 15100.00, 21140.00, 0, 2, 0, 0, '2026-04-12 14:09:43', '2026-04-12 14:09:43', NULL),
(865, 862, 7, '162510', NULL, '2028-10-12', 17250.00, 24150.00, 0, 1, 0, 0, '2026-04-12 14:13:34', '2026-04-12 14:13:34', NULL),
(866, 863, 7, 'P793', NULL, '2028-04-30', 1570.00, 2200.00, 0, 6, 1, 0, '2026-04-12 14:30:07', '2026-04-12 14:30:07', NULL),
(867, 864, 7, 'FIRST AID', NULL, '2028-12-12', 20900.00, 29300.00, 0, 1, 0, 0, '2026-04-12 14:38:09', '2026-04-12 14:38:09', NULL),
(868, 630, 7, 'EE5030', NULL, '2028-07-31', 3850.00, 5400.00, 0, 1, 0, 0, '2026-04-12 14:41:17', '2026-04-12 14:41:17', NULL),
(869, 865, 7, '25', NULL, '2027-08-31', 3150.00, 4450.00, 0, 1, 1, 0, '2026-04-12 14:46:06', '2026-04-12 14:46:06', NULL),
(870, 866, 7, 'A80126J', NULL, '2029-01-01', 840.00, 1200.00, 0, 12, 2, 0, '2026-04-12 14:47:19', '2026-04-12 14:47:19', NULL),
(871, 867, 7, '1855E03', NULL, '2029-07-31', 1900.00, 2700.00, 0, 6, 1, 0, '2026-04-12 14:50:06', '2026-04-12 14:50:06', NULL),
(872, 868, 7, '29531834', NULL, '2027-05-12', 13380.00, 18750.00, 0, 1, 0, 0, '2026-04-12 14:50:56', '2026-04-12 14:50:56', NULL),
(873, 869, 7, 'CAY0062', NULL, '2027-12-12', 8030.00, 11250.00, 0, 1, 0, 0, '2026-04-12 14:53:38', '2026-04-12 14:53:38', NULL),
(874, 870, 7, '2391', NULL, '2030-12-31', 1800.00, 2550.00, 0, 2, 1, 0, '2026-04-12 14:54:42', '2026-04-12 14:54:42', NULL),
(875, 871, 7, '1224FD', NULL, '2027-12-10', 254.00, 350.00, 0, 10, 2, 0, '2026-04-12 14:58:17', '2026-04-12 14:58:17', NULL),
(876, 872, 7, 'VGT250097', NULL, '2028-05-12', 310.00, 450.00, 0, 10, 2, 0, '2026-04-12 15:01:33', '2026-04-12 15:01:33', NULL),
(877, 873, 7, 'VGT250074', NULL, '2028-02-12', 230.00, 350.00, 0, 10, 2, 0, '2026-04-12 15:03:55', '2026-04-12 15:03:55', NULL),
(878, 874, 7, '2501272', NULL, '2028-03-31', 9695.00, 13600.00, 0, 1, 1, 0, '2026-04-12 15:05:56', '2026-04-12 15:05:56', NULL),
(879, 875, 7, 'GS0226008', NULL, '2027-04-12', 340.00, 500.00, 0, 50, 20, 0, '2026-04-12 15:07:24', '2026-04-12 15:07:24', NULL),
(880, 876, 7, '25206GI', NULL, '2030-07-12', 9100.00, 12750.00, 0, 1, 0, 0, '2026-04-12 15:13:11', '2026-04-12 15:13:11', NULL),
(881, 877, 7, '25H05J2', NULL, '2028-08-04', 6000.00, 8400.00, 0, 5, 2, 0, '2026-04-12 15:14:44', '2026-04-12 15:14:44', NULL),
(882, 878, 7, '25240LMS', NULL, '2028-08-12', 12450.00, 17450.00, 0, 1, 0, 0, '2026-04-12 15:15:24', '2026-04-12 15:15:24', NULL),
(883, 879, 7, 'CE12056', NULL, '2027-11-30', 2100.00, 2950.00, 0, 2, 1, 0, '2026-04-12 15:19:07', '2026-04-12 15:19:07', NULL),
(884, 880, 7, '9YD9', NULL, '2028-02-12', 5248.30, 7350.00, 0, 3, 0, 0, '2026-04-12 15:20:58', '2026-04-12 15:20:58', NULL),
(885, 881, 7, '2501274', NULL, '2028-01-31', 9110.00, 12750.00, 0, 1, 1, 0, '2026-04-12 15:21:40', '2026-04-12 15:21:40', NULL),
(886, 421, 7, 'PW2756', NULL, '2030-09-12', 1000.00, 1400.00, 0, 2, 1, 0, '2026-04-12 15:25:25', '2026-04-12 15:25:25', NULL),
(887, 882, 7, 'PV5861', NULL, '2030-09-12', 900.00, 1260.00, 0, 2, 0, 0, '2026-04-12 15:28:31', '2026-04-12 15:28:31', NULL),
(888, 883, 7, '2412213', NULL, '2028-01-31', 10915.00, 15300.00, 0, 1, 1, 0, '2026-04-12 15:29:42', '2026-04-12 15:29:42', NULL),
(889, 884, 7, '2412162', NULL, '2028-01-12', 10060.00, 14100.00, 0, 1, 0, 0, '2026-04-12 15:32:33', '2026-04-12 15:32:33', NULL),
(890, 885, 7, '3238E', NULL, '2028-12-31', 4.20, 10.00, 0, 1000, 100, 0, '2026-04-12 15:33:07', '2026-04-12 15:33:07', NULL),
(891, 886, 7, '2501262', NULL, '2028-01-31', 9900.00, 13900.00, 0, 1, 1, 0, '2026-04-12 15:36:15', '2026-04-12 15:36:15', NULL),
(892, 887, 7, '2511029', NULL, '2028-10-12', 4180.00, 5850.00, 0, 3, 1, 0, '2026-04-12 15:38:24', '2026-04-12 15:38:24', NULL),
(893, 888, 7, '2501263', NULL, '2028-01-31', 11860.00, 16600.00, 0, 1, 1, 0, '2026-04-12 15:38:31', '2026-04-12 15:38:31', NULL),
(894, 889, 7, 'C522503011', NULL, '2028-03-31', 20100.00, 28150.00, 0, 1, 1, 0, '2026-04-12 15:41:54', '2026-04-12 15:41:54', NULL),
(895, 890, 7, '856478581', NULL, '2030-07-12', 333.30, 450.00, 0, 60, 12, 0, '2026-04-12 15:43:18', '2026-04-12 15:43:18', NULL),
(896, 891, 7, 'AMPA5EY', NULL, '2027-09-30', 353.33, 500.00, 0, 30, 6, 0, '2026-04-12 15:46:25', '2026-04-12 15:46:25', NULL),
(897, 892, 7, '2412164', NULL, '2028-03-12', 9375.00, 13150.00, 0, 1, 0, 0, '2026-04-12 15:46:47', '2026-04-12 15:46:47', NULL),
(898, 893, 7, 'B725025A', NULL, '2028-07-12', 4260.00, 6000.00, 0, 10, 2, 0, '2026-04-12 15:51:42', '2026-04-12 15:51:42', NULL),
(899, 894, 7, '593570', NULL, '2028-11-30', 16585.00, 23250.00, 0, 1, 1, 0, '2026-04-12 15:52:32', '2026-04-12 15:52:32', NULL),
(900, 895, 7, 'CN25023', NULL, '2029-05-12', 3500.00, 4900.00, 0, 10, 2, 0, '2026-04-12 15:54:36', '2026-04-12 15:54:36', NULL),
(901, 896, 7, 'LAUP5-23', NULL, '2030-05-15', 3300.00, 4650.00, 0, 1, 1, 0, '2026-04-12 15:58:25', '2026-04-12 15:58:25', NULL),
(902, 897, 7, 'COG016L', NULL, '2027-07-12', 980.00, 1400.00, 0, 3, 1, 0, '2026-04-12 15:58:57', '2026-04-12 15:58:57', NULL),
(903, 898, 7, '729640', NULL, '2028-11-30', 14500.00, 20300.00, 0, 1, 1, 0, '2026-04-12 16:02:50', '2026-04-12 16:02:50', NULL),
(904, 899, 7, 'DZBHH0079', NULL, '2028-06-12', 4250.00, 5950.00, 0, 3, 1, 0, '2026-04-12 16:04:22', '2026-04-12 16:04:22', NULL),
(905, 900, 7, 'DZAHH0022', NULL, '2028-03-12', 3206.60, 4500.00, 0, 3, 1, 0, '2026-04-12 16:07:38', '2026-04-12 16:07:38', NULL),
(906, 901, 7, 'AGH7561', NULL, '2028-11-12', 1500.00, 1950.00, 0, 6, 1, 0, '2026-04-12 16:10:03', '2026-04-12 16:10:03', NULL),
(907, 902, 7, 'L225041', NULL, '2030-01-20', 51.40, 100.00, 0, 100, 10, 0, '2026-04-12 16:13:59', '2026-04-12 16:13:59', NULL),
(908, 903, 7, 'DVD006L', NULL, '2027-06-12', 700.00, 1000.00, 0, 2, 1, 0, '2026-04-12 16:21:56', '2026-04-12 16:21:56', NULL),
(909, 904, 7, 'CDe85', NULL, '2029-02-06', 530.00, 750.00, 0, 4, 2, 0, '2026-04-12 16:25:33', '2026-04-12 16:25:33', NULL),
(910, 905, 7, 'LAAD11-50', NULL, '2030-07-12', 8560.00, 12000.00, 0, 1, 0, 0, '2026-04-12 16:31:32', '2026-04-12 16:31:32', NULL),
(911, 906, 7, 'LAAD9-52', NULL, '2030-11-12', 8560.00, 12000.00, 0, 1, 0, 0, '2026-04-12 16:34:35', '2026-04-12 16:34:35', NULL),
(912, 907, 7, 'LAAD8-11', NULL, '2030-12-12', 8640.00, 12100.00, 0, 1, 0, 0, '2026-04-12 16:36:39', '2026-04-12 16:36:39', NULL),
(913, 908, 7, 'LAAPUD10-3', NULL, '2028-08-12', 7580.00, 10600.00, 0, 1, 0, 0, '2026-04-12 16:40:33', '2026-04-12 16:40:33', NULL),
(914, 909, 7, '1270425', NULL, '2027-03-31', 2335.00, 3000.00, 0, 12, 3, 0, '2026-04-13 10:36:49', '2026-04-13 10:36:49', NULL),
(915, 910, 7, '5199834761', NULL, '2030-11-30', 2700.00, 3350.00, 0, 3, 1, 0, '2026-04-13 10:58:22', '2026-04-13 10:58:22', NULL),
(916, 911, 7, 'FL23', NULL, '2026-12-25', 383.00, 600.00, 0, 12, 3, 0, '2026-04-13 11:03:37', '2026-04-13 11:03:37', NULL),
(917, 912, 7, '05/2025', NULL, '2030-05-13', 791.00, 1000.00, 0, 12, 5, 0, '2026-04-13 11:07:39', '2026-04-13 11:07:39', NULL),
(918, 913, 7, '056', NULL, '2032-04-24', 333.00, 500.00, 0, 12, 5, 0, '2026-04-13 11:13:23', '2026-04-13 11:13:23', NULL),
(919, 914, 7, '011', NULL, '2031-11-24', 333.00, 500.00, 0, 12, 5, 0, '2026-04-13 11:15:53', '2026-04-13 11:15:53', NULL),
(920, 915, 7, '0311', NULL, '2027-11-06', 1083.00, 1500.00, 0, 6, 2, 0, '2026-04-13 11:19:06', '2026-04-13 11:19:06', NULL),
(921, 916, 7, '2001', NULL, '2028-01-28', 1081.00, 1500.00, 0, 2, 0, 0, '2026-04-13 11:21:58', '2026-04-13 11:21:58', NULL),
(922, 917, 7, '0202', NULL, '2028-02-17', 1083.00, 1500.00, 0, 2, 1, 0, '2026-04-13 11:27:41', '2026-04-13 11:27:41', NULL),
(923, 918, 7, 'A8', NULL, '2026-07-20', 154.00, 200.00, 0, 50, 10, 0, '2026-04-13 11:34:59', '2026-04-13 11:34:59', NULL),
(924, 919, 7, 'NG02', NULL, '2029-01-11', 1000.00, 1100.00, 0, 5, 2, 0, '2026-04-13 11:43:10', '2026-04-13 11:43:10', NULL),
(925, 920, 7, 'NG4', NULL, '2029-03-21', 1000.00, 1100.00, 0, 5, 3, 0, '2026-04-13 11:46:14', '2026-04-13 11:46:14', NULL),
(926, 921, 7, 'NG4ZP', NULL, '2028-11-15', 5500.00, 6000.00, 0, 1, 0, 0, '2026-04-13 11:50:29', '2026-04-13 11:50:29', NULL),
(927, 922, 7, 'NG6ZP', NULL, '2028-12-19', 5500.00, 6000.00, 0, 0, 0, 0, '2026-04-13 11:53:27', '2026-04-18 11:30:40', NULL),
(928, 923, 7, 'NG7ZP', NULL, '2029-01-01', 5500.00, 6000.00, 0, 1, 0, 0, '2026-04-13 11:57:00', '2026-04-13 11:57:00', NULL),
(929, 925, 7, 'N11', NULL, '2028-11-15', 5650.00, 6500.00, 0, 2, 1, 0, '2026-04-13 12:10:34', '2026-04-13 12:10:34', NULL),
(930, 926, 7, 'N11', NULL, '2029-01-20', 5650.00, 6500.00, 0, 1, 0, 0, '2026-04-13 12:13:26', '2026-04-13 12:13:26', NULL),
(931, 927, 7, 'N7', NULL, '2029-11-15', 5650.00, 6500.00, 0, 1, 0, 0, '2026-04-13 12:17:59', '2026-04-13 12:17:59', NULL),
(932, 928, 7, '25F077', NULL, '2028-06-06', 1155.00, 1600.00, 0, 10, 3, 0, '2026-04-15 13:43:47', '2026-04-15 13:43:47', NULL),
(933, 929, 7, '25ZB05', '2025-08-01', '2028-07-01', 965.00, 1254.50, 0, 5, 2, 0, '2026-04-15 13:53:20', '2026-04-15 13:53:20', NULL),
(934, 931, 7, 'L1026002', '2026-01-01', '2027-12-01', 770.00, 1050.00, 0, 3, 1, 0, '2026-04-15 14:11:04', '2026-04-15 14:11:04', NULL),
(935, 932, 7, 'TMTP0037', '2025-09-01', '2028-08-01', 1530.00, 2000.00, 0, 3, 1, 0, '2026-04-15 14:23:54', '2026-04-15 14:23:54', NULL),
(936, 933, 7, 'EL0225', '2025-04-01', '2027-09-01', 1783.33, 2350.43, 0, 3, 1, 0, '2026-04-15 14:29:05', '2026-04-15 14:29:05', NULL),
(937, 934, 7, 'TVTP0047', '2025-10-01', '2028-09-01', 1900.00, 2500.00, 0, 3, 1, 0, '2026-04-15 14:33:38', '2026-04-15 14:33:38', NULL),
(938, 935, 7, 'WE2505TA', '2025-06-01', '2028-05-01', 12000.00, 16000.00, 0, 1, 1, 0, '2026-04-15 14:40:08', '2026-04-15 14:40:08', NULL),
(939, 936, 7, '2511012A', '2025-11-01', '2028-10-01', 1333.33, 1750.00, 0, 3, 1, 0, '2026-04-15 14:54:40', '2026-04-17 12:00:03', NULL),
(940, 937, 7, 'TAMS56002', '2025-10-01', '2028-09-01', 2496.67, 2600.00, 0, 3, 1, 0, '2026-04-17 08:15:36', '2026-04-17 08:15:36', NULL),
(941, 938, 7, '240820', '2024-08-01', '2029-07-01', 47.00, 100.00, 0, 100, 1, 0, '2026-04-17 08:28:17', '2026-04-17 08:28:17', NULL),
(942, 940, 7, '2601A', '2026-01-19', '2027-01-18', 3530.00, 4000.00, 0, 1, 1, 0, '2026-04-17 08:36:51', '2026-04-17 08:36:51', NULL),
(943, 941, 7, 'OHH25031', '2025-11-01', '2027-10-01', 6600.00, 8900.00, 0, 1, 1, 0, '2026-04-17 08:41:38', '2026-04-17 08:41:38', NULL),
(944, 942, 7, '250602', '2025-06-01', '2028-05-01', 380.00, 500.00, 0, 10, 1, 0, '2026-04-17 08:47:30', '2026-04-17 08:47:30', NULL),
(945, 943, 7, '25k005', NULL, '2028-11-01', 12200.00, 16000.00, 0, 1, 1, 0, '2026-04-17 08:53:07', '2026-04-17 08:53:07', NULL),
(946, 945, 7, 'T1ABG027', '2025-08-01', '2028-07-01', 400.00, 550.00, 0, 10, 1, 0, '2026-04-17 09:13:17', '2026-04-17 09:13:17', NULL),
(947, 946, 7, '0027', '0025-06-02', '2027-06-02', 4815.00, 6300.00, 0, 1, 1, 0, '2026-04-17 09:19:45', '2026-04-17 09:19:45', NULL),
(948, 947, 7, 'A404', '2024-04-01', '2027-03-01', 730.00, 1000.00, 0, 2, 1, 0, '2026-04-17 09:30:12', '2026-04-17 09:30:12', NULL),
(949, 948, 7, 'AJ111(01)', NULL, '2027-12-14', 3500.00, 4250.00, 0, 2, 1, 0, '2026-04-17 09:37:19', '2026-04-17 09:37:19', NULL),
(950, 949, 7, 'KT1752', '2024-12-01', '2027-11-01', 1321.43, 1800.00, 0, 14, 1, 0, '2026-04-17 09:39:16', '2026-04-17 09:39:16', NULL),
(951, 950, 7, 'KLM/6665', NULL, '2027-12-31', 3500.00, 4250.00, 0, 3, 1, 0, '2026-04-17 09:40:33', '2026-04-17 09:40:33', NULL),
(952, 951, 7, 'E16P025013', '2025-09-01', '2028-08-01', 2300.00, 3000.00, 0, 6, 1, 0, '2026-04-17 09:45:45', '2026-04-17 09:45:45', NULL),
(953, 953, 7, 'KIL716', NULL, '2028-11-30', 7000.00, 8500.00, 0, 2, 1, 0, '2026-04-17 09:48:16', '2026-04-17 09:48:16', NULL),
(954, 954, 7, '23041', '2023-12-01', '2028-11-01', 280.00, 400.00, 0, 5, 1, 0, '2026-04-17 09:49:44', '2026-04-17 09:49:44', NULL),
(955, 955, 7, '798304167078', NULL, '2028-03-12', 3700.00, 4200.00, 0, 2, 1, 0, '2026-04-17 09:53:35', '2026-04-17 09:53:35', NULL),
(956, 956, 7, 'ACNH0024', '2025-10-01', '2028-09-01', 1063.33, 1400.00, 0, 3, 1, 0, '2026-04-17 10:01:54', '2026-04-17 10:01:54', NULL),
(957, 957, 7, '234', NULL, '2027-01-17', 185.00, 250.00, 0, 28, 5, 0, '2026-04-17 10:06:48', '2026-04-17 10:06:48', NULL),
(958, 958, 7, 'YP260103', '2026-01-01', '2028-12-01', 570.00, 800.00, 0, 2, 1, 0, '2026-04-17 10:07:48', '2026-04-17 10:07:48', NULL),
(959, 959, 7, '2050226C26', NULL, '2026-08-04', 500.00, 650.00, 0, 24, 7, 0, '2026-04-17 10:11:42', '2026-04-17 10:11:42', NULL),
(960, 960, 7, 'E16PN26003', '2026-01-01', '2028-12-01', 1300.00, 1700.00, 0, 6, 1, 0, '2026-04-17 10:11:50', '2026-04-17 10:11:50', NULL),
(961, 961, 7, 'CHI212', NULL, '2030-11-29', 1300.00, 2000.00, 0, 5, 2, 0, '2026-04-17 10:15:35', '2026-04-17 10:15:35', NULL),
(962, 963, 7, 'DFG2350A', '2025-04-01', '2027-03-01', 8000.00, 10500.00, 0, 1, 1, 0, '2026-04-17 10:17:27', '2026-04-17 10:17:27', NULL),
(963, 964, 7, '241515', '2025-03-01', '2030-02-01', 180.00, 250.00, 0, 10, 1, 0, '2026-04-17 10:21:16', '2026-04-17 10:21:16', NULL),
(964, 965, 7, '233373', '2023-12-01', '2028-12-01', 10500.00, 13700.00, 0, 2, 1, 0, '2026-04-17 10:38:53', '2026-04-17 10:38:53', NULL),
(965, 966, 7, '6IID004', '2026-02-01', '2028-01-01', 2133.33, 2800.00, 0, 3, 1, 0, '2026-04-17 10:47:15', '2026-04-17 10:47:15', NULL),
(966, 968, 7, 'E8WR1A', NULL, '2028-10-01', 10700.00, 14000.00, 0, 1, 1, 0, '2026-04-17 10:52:48', '2026-04-17 10:52:48', NULL),
(967, 967, 7, 'ASP0226', NULL, '2028-02-29', 500.00, 650.00, 0, 24, 10, 0, '2026-04-17 10:54:50', '2026-04-17 10:54:50', NULL),
(968, 971, 7, '0266', '2025-07-01', '2028-06-01', 104.00, 150.00, 0, 10, 1, 0, '2026-04-17 10:58:49', '2026-04-17 10:58:49', NULL),
(969, 970, 7, 'ASP0226', NULL, '2028-02-29', 625.00, 750.00, 0, 11, 5, 0, '2026-04-17 10:59:22', '2026-04-18 11:30:40', NULL),
(970, 972, 7, 'FC5510', '2025-03-01', '2028-02-01', 715.00, 1000.00, 0, 12, 1, 0, '2026-04-17 11:03:34', '2026-04-17 11:03:34', NULL),
(971, 974, 7, '01026N', NULL, '2027-01-10', 2833.00, 3500.00, 0, 12, 3, 0, '2026-04-17 13:06:17', '2026-04-17 13:06:17', NULL),
(972, 975, 7, '02726N', NULL, '2027-01-26', 9667.00, 11000.00, 0, 3, 1, 0, '2026-04-17 13:13:05', '2026-04-17 13:13:05', NULL),
(973, 976, 7, '2411391616', NULL, '2029-10-01', 1875.00, 2500.00, 0, 6, 1, 1, '2026-04-17 13:14:02', '2026-04-17 13:14:02', NULL),
(974, 978, 7, 'EM4014', '2024-03-01', '2027-02-01', 2140.00, 2800.00, 0, 3, 1, 1, '2026-04-17 13:38:02', '2026-04-17 13:38:02', NULL),
(975, 979, 7, 'MT7412', '2026-03-01', '2029-02-01', 166.67, 250.00, 0, 60, 1, 10, '2026-04-17 14:06:37', '2026-04-17 14:06:37', NULL),
(976, 980, 7, 'S25F057', '2025-06-01', '2027-08-30', 1550.00, 2100.00, 0, 4, 1, 1, '2026-04-17 14:30:39', '2026-04-18 14:10:26', NULL),
(977, 519, 7, '12/10/15', NULL, '2028-03-14', 350.00, 450.00, 0, 5, 2, 0, '2026-04-18 08:51:46', '2026-04-18 08:54:33', NULL),
(978, 16, 7, '2014725', NULL, '2026-04-25', 850.00, 1100.00, 0, 0, 1, 1, '2026-04-18 09:28:54', '2026-04-18 09:33:09', NULL),
(979, 987, 7, '2014725', NULL, '2028-10-30', 825.00, 1100.00, 0, 8, 3, 0, '2026-04-18 11:12:07', '2026-04-20 09:42:47', NULL),
(980, 988, 7, '14', NULL, '2027-04-13', 167.00, 250.00, 0, 94, 10, 0, '2026-04-18 11:21:02', '2026-04-20 12:36:36', NULL),
(981, 989, 7, 'DLDR18', NULL, '2027-09-01', 1100.00, 1550.00, 0, 5, 2, 0, '2026-04-18 11:29:41', '2026-04-18 11:29:41', NULL),
(982, 990, 7, 'L241067', NULL, '2027-05-01', 642.00, 900.00, 0, 30, 10, 0, '2026-04-18 11:35:58', '2026-04-18 11:35:58', NULL),
(983, 991, 7, 'AGZ893', NULL, '2027-03-31', 7800.00, 10950.00, 0, 1, 1, 0, '2026-04-18 11:44:33', '2026-04-18 11:44:33', NULL),
(984, 992, 7, '1-1-14', NULL, '2026-10-01', 1500.00, 1950.00, 0, 10, 3, 0, '2026-04-18 11:47:35', '2026-04-18 11:47:35', NULL),
(985, 993, 7, 'SV118', NULL, '2027-10-30', 8020.00, 11250.00, 0, 2, 2, 0, '2026-04-18 11:50:16', '2026-04-18 11:50:16', NULL),
(986, 977, 7, '262A', NULL, '2027-12-12', 1083.00, 1400.00, 0, 12, 3, 0, '2026-04-18 11:51:41', '2026-04-18 11:51:41', NULL),
(987, 994, 7, 'PRW2431AA', NULL, '2027-11-30', 11000.00, 15400.00, 0, 1, 1, 0, '2026-04-18 11:53:44', '2026-04-18 11:53:44', NULL),
(988, 995, 7, '711', NULL, '2026-12-17', 900.00, 1000.00, 0, 19, 5, 0, '2026-04-18 11:57:04', '2026-04-18 12:49:18', NULL),
(989, 996, 7, '6446689', NULL, '2028-08-31', 21780.00, 30500.00, 0, 1, 1, 0, '2026-04-18 11:58:21', '2026-04-18 11:58:21', NULL),
(990, 997, 7, '646', NULL, '2027-03-03', 935.00, 1000.00, 0, 20, 5, 0, '2026-04-18 12:00:12', '2026-04-18 12:00:12', NULL),
(991, 998, 7, '280D1', NULL, '2027-09-01', 18000.00, 25200.00, 0, 1, 1, 0, '2026-04-18 12:01:48', '2026-04-18 12:01:48', NULL),
(992, 999, 7, '6846', NULL, '2027-08-31', 150.00, 200.00, 0, 50, 10, 0, '2026-04-18 12:03:40', '2026-04-18 12:03:40', NULL),
(993, 1000, 7, 'PP2542', NULL, '2028-02-29', 20800.00, 29150.00, 0, 1, 1, 0, '2026-04-18 12:07:56', '2026-04-18 12:07:56', NULL),
(994, 1001, 7, '051', NULL, '2028-10-03', 3350.00, 3800.00, 0, 10, 3, 0, '2026-04-18 12:09:05', '2026-04-18 12:09:05', NULL),
(995, 1003, 7, 'QTGR25015', NULL, '2028-02-29', 17655.00, 24750.00, 0, 1, 1, 0, '2026-04-18 12:23:48', '2026-04-18 12:23:48', NULL),
(996, 1002, 7, '5305', NULL, '2028-10-16', 2500.00, 3000.00, 0, 10, 3, 0, '2026-04-18 12:26:31', '2026-04-18 12:26:31', NULL),
(997, 1004, 7, '51062`', NULL, '2028-01-31', 10500.00, 14700.00, 0, 2, 0, 0, '2026-04-18 12:26:40', '2026-04-18 12:26:40', NULL),
(998, 1005, 7, '121', NULL, '2028-02-22', 2583.00, 3000.00, 0, 12, 3, 0, '2026-04-18 12:30:48', '2026-04-18 12:30:48', NULL),
(999, 1006, 7, 'F177676', NULL, '2027-09-30', 12420.00, 17400.00, 0, 1, 1, 0, '2026-04-18 12:31:21', '2026-04-18 12:31:21', NULL),
(1000, 1007, 7, '51594', NULL, '2027-12-31', 16900.00, 23700.00, 0, 1, 1, 0, '2026-04-18 12:34:04', '2026-04-18 12:34:04', NULL),
(1001, 1008, 7, '2025', NULL, '2028-05-19', 1800.00, 2500.00, 0, 4, 0, 0, '2026-04-18 12:36:56', '2026-04-18 13:05:08', NULL),
(1002, 1009, 7, 'T44238A', NULL, '2028-04-30', 1750.00, 2450.00, 0, 12, 4, 0, '2026-04-18 12:37:33', '2026-04-18 12:37:33', NULL),
(1003, 1010, 7, '52662', NULL, '2028-10-31', 13910.00, 19500.00, 0, 1, 1, 0, '2026-04-18 12:42:03', '2026-04-18 12:42:03', NULL),
(1004, 1011, 7, '51606', NULL, '2028-04-30', 15785.00, 22100.00, 0, 1, 1, 0, '2026-04-18 12:46:49', '2026-04-18 12:46:49', NULL),
(1005, 1012, 7, '51588', NULL, '2028-04-30', 14445.00, 20250.00, 0, 1, 1, 0, '2026-04-18 12:50:08', '2026-04-18 12:50:08', NULL),
(1006, 1013, 7, '51601', NULL, '2028-04-30', 14445.00, 20250.00, 0, 1, 1, 0, '2026-04-18 12:53:33', '2026-04-18 12:53:33', NULL),
(1007, 1014, 7, '51176', NULL, '2028-01-31', 18150.00, 25450.00, 0, 1, 1, 0, '2026-04-18 12:56:14', '2026-04-18 12:56:14', NULL),
(1008, 1015, 7, '51621', NULL, '2028-04-30', 14780.00, 20700.00, 0, 1, 1, 0, '2026-04-18 12:58:47', '2026-04-18 12:58:47', NULL),
(1009, 1016, 7, '51538', NULL, '2028-04-30', 19250.00, 26950.00, 0, 2, 1, 0, '2026-04-18 13:02:27', '2026-04-18 13:04:27', NULL),
(1010, 1017, 7, '51648', NULL, '2028-04-30', 10165.00, 14250.00, 0, 1, 1, 0, '2026-04-18 13:07:17', '2026-04-18 13:07:17', NULL),
(1011, 1018, 7, '714', NULL, '2028-02-29', 500.00, 700.00, 0, 1, 1, 0, '2026-04-18 13:09:25', '2026-04-18 13:09:25', NULL),
(1012, 1019, 7, '006', NULL, '2030-10-23', 3000.00, 3900.00, 0, 6, 2, 0, '2026-04-18 13:11:06', '2026-04-18 13:11:06', NULL),
(1013, 1020, 7, '120224126', NULL, '2028-01-30', 18190.00, 25500.00, 0, 1, 1, 0, '2026-04-18 13:11:35', '2026-04-18 13:11:35', NULL),
(1014, 1021, 7, 'L086F', NULL, '2029-02-28', 650.00, 950.00, 0, 10, 2, 0, '2026-04-18 13:14:40', '2026-04-18 13:14:40', NULL),
(1015, 1022, 7, '930925', NULL, '2028-09-30', 14300.00, 20000.00, 0, 1, 1, 0, '2026-04-18 13:21:38', '2026-04-18 13:21:38', NULL),
(1016, 1023, 7, '2501275', NULL, '2028-01-31', 8645.00, 12100.00, 0, 1, 1, 0, '2026-04-18 13:25:47', '2026-04-18 13:25:47', NULL),
(1017, 1025, 7, '24264F42', NULL, '2027-09-30', 20200.00, 28300.00, 0, 1, 1, 0, '2026-04-18 13:29:32', '2026-04-18 13:29:32', NULL),
(1018, 1024, 7, '003', NULL, '2030-12-30', 1900.00, 2500.00, 0, 4, 1, 0, '2026-04-18 13:30:06', '2026-04-18 13:30:06', NULL),
(1019, 1026, 7, 'XT5G026', NULL, '2029-06-30', 300.00, 450.00, 0, 6, 4, 0, '2026-04-18 13:36:23', '2026-04-18 13:36:23', NULL),
(1020, 1027, 7, '51547LD', NULL, '2030-11-22', 3600.00, 4500.00, 0, 2, 1, 0, '2026-04-18 13:39:26', '2026-04-18 13:39:26', NULL),
(1021, 1028, 7, 'ACE26001', NULL, '2029-01-31', 1180.00, 1700.00, 0, 3, 2, 0, '2026-04-18 13:40:52', '2026-04-18 13:40:52', NULL),
(1022, 1029, 7, '51507LD', NULL, '2030-10-29', 3600.00, 4500.00, 0, 2, 1, 0, '2026-04-18 13:43:49', '2026-04-18 13:43:49', NULL),
(1023, 1030, 7, '324-1318', NULL, '2027-09-30', 1925.00, 2700.00, 0, 5, 2, 0, '2026-04-18 13:44:19', '2026-04-18 13:44:19', NULL),
(1024, 1031, 7, 'M25F012', NULL, '2027-11-30', 1100.00, 1550.00, 0, 3, 3, 0, '2026-04-18 13:50:27', '2026-04-18 13:50:27', NULL),
(1025, 1032, 7, 'B092', NULL, '2031-01-14', 3600.00, 4700.00, 0, 2, 1, 0, '2026-04-18 13:51:22', '2026-04-18 13:51:22', NULL),
(1026, 1033, 7, 'S2421045', NULL, '2027-10-31', 1135.00, 1600.00, 0, 3, 3, 0, '2026-04-18 13:54:18', '2026-04-18 13:54:18', NULL),
(1027, 1034, 7, 'A311009', NULL, '2027-11-14', 1600.00, 2250.00, 0, 1, 1, 0, '2026-04-18 13:57:48', '2026-04-18 13:57:48', NULL),
(1028, 1035, 7, '20230328', NULL, '2028-03-27', 1250.00, 1750.00, 0, 2, 2, 0, '2026-04-18 14:01:44', '2026-04-18 14:01:44', NULL),
(1029, 1036, 7, '24410', NULL, '2026-11-11', 635.00, 900.00, 0, 2, 1, 0, '2026-04-18 14:04:41', '2026-04-18 14:04:41', NULL),
(1030, 1038, 7, 'S25C031', NULL, '2027-08-31', 1100.00, 1550.00, 0, 5, 2, 0, '2026-04-18 14:13:03', '2026-04-18 14:13:03', NULL),
(1031, 1037, 7, '912B', NULL, '2030-10-18', 3500.00, 4000.00, 0, 1, 0, 0, '2026-04-18 14:14:24', '2026-04-18 14:14:24', NULL),
(1032, 1039, 7, '0HT25100', NULL, '2027-06-30', 10500.00, 14700.00, 0, 1, 1, 0, '2026-04-18 14:16:32', '2026-04-18 14:16:32', NULL),
(1033, 1040, 7, '812C', NULL, '2030-11-18', 3500.00, 4000.00, 0, 1, 0, 0, '2026-04-18 14:19:24', '2026-04-18 14:19:24', NULL),
(1034, 382, 7, 'ANNH0026', NULL, '2028-06-30', 1245.00, 1750.00, 0, 3, 3, 0, '2026-04-18 14:20:11', '2026-04-18 14:20:11', NULL),
(1035, 1041, 7, '212B', NULL, '2030-11-26', 3500.00, 4000.00, 0, 1, 0, 0, '2026-04-18 14:22:11', '2026-04-18 14:22:11', NULL),
(1036, 1042, 7, 'L4PP', NULL, '2027-09-30', 2300.00, 3000.00, 0, 2, 0, 0, '2026-04-18 14:25:23', '2026-04-18 14:25:23', NULL),
(1037, 1043, 7, 'AE21722', NULL, '2028-01-31', 1070.00, 1500.00, 0, 5, 2, 0, '2026-04-18 14:26:33', '2026-04-18 14:26:33', NULL),
(1038, 1044, 7, 'AE06153', NULL, '2027-09-30', 860.00, 1250.00, 0, 3, 2, 0, '2026-04-18 14:30:29', '2026-04-18 14:30:29', NULL),
(1039, 1045, 7, '2026', NULL, '2031-02-08', 2400.00, 4500.00, 0, 3, 1, 0, '2026-04-18 14:33:15', '2026-04-18 14:33:15', NULL),
(1040, 1047, 7, 'H23042', NULL, '2028-11-17', 180.00, 250.00, 0, 10, 2, 0, '2026-04-18 14:36:40', '2026-04-18 14:36:40', NULL),
(1041, 1046, 7, '225', NULL, '2031-10-18', 1800.00, 2500.00, 0, 2, 0, 0, '2026-04-18 14:38:42', '2026-04-18 14:38:42', NULL),
(1042, 1048, 7, '240882', NULL, '2029-09-30', 145.00, 250.00, 0, 10, 2, 0, '2026-04-18 14:41:29', '2026-04-18 14:41:29', NULL),
(1043, 1050, 7, '25307', NULL, '2027-10-31', 610.00, 900.00, 0, 2, 1, 0, '2026-04-18 14:44:09', '2026-04-18 14:44:09', NULL),
(1044, 1049, 7, '5023', NULL, '2031-12-31', 1800.00, 2500.00, 0, 4, 0, 0, '2026-04-18 14:46:44', '2026-04-18 14:46:44', NULL),
(1045, 1051, 7, '002', NULL, '2027-06-10', 295.00, 450.00, 0, 2, 1, 0, '2026-04-18 14:46:59', '2026-04-18 14:46:59', NULL),
(1046, 1052, 7, '6013K', NULL, '2029-01-31', 800.00, 1150.00, 0, 6, 2, 0, '2026-04-18 14:53:36', '2026-04-18 14:53:36', NULL),
(1047, 1053, 7, 'ABH7500', NULL, '2027-11-30', 1800.00, 2500.00, 0, 4, 1, 0, '2026-04-18 14:56:59', '2026-04-18 14:56:59', NULL),
(1048, 1055, 7, 'EMF25001', NULL, '2028-01-31', 3000.00, 4200.00, 0, 5, 2, 0, '2026-04-18 14:59:25', '2026-04-18 14:59:25', NULL),
(1049, 1054, 7, 'ABH8082', NULL, '2027-11-30', 550.00, 750.00, 0, 6, 2, 0, '2026-04-18 15:01:07', '2026-04-18 15:01:07', NULL),
(1050, 1056, 7, 'EEN504', NULL, '2027-12-30', 200.00, 300.00, 0, 6, 4, 0, '2026-04-18 15:02:23', '2026-04-18 15:47:07', NULL),
(1051, 1058, 7, 'L566E', NULL, '2027-05-31', 700.00, 1000.00, 0, 5, 2, 0, '2026-04-18 15:05:47', '2026-04-18 15:05:47', NULL),
(1052, 1057, 7, '333', NULL, '2031-10-30', 3000.00, 3900.00, 0, 3, 1, 0, '2026-04-18 15:05:59', '2026-04-18 15:05:59', NULL),
(1053, 1059, 7, 'B9467N', NULL, '2027-12-31', 15500.00, 21700.00, 0, 2, 2, 0, '2026-04-18 15:09:13', '2026-04-18 15:09:13', NULL),
(1054, 601, 7, '53b25044A', NULL, '2027-08-31', 980.00, 1400.00, 0, 10, 0, 0, '2026-04-18 15:11:04', '2026-04-18 15:11:04', NULL),
(1055, 1060, 7, '50972AV07', NULL, '2031-12-30', 1125.00, 2500.00, 0, 4, 1, 0, '2026-04-18 15:13:45', '2026-04-18 15:13:45', NULL),
(1056, 1061, 7, 'AE15263', NULL, '2027-11-30', 1500.00, 2100.00, 0, 3, 2, 0, '2026-04-18 15:14:41', '2026-04-18 15:14:41', NULL),
(1057, 1062, 7, '25D05C1', NULL, '2027-04-04', 4166.67, 5950.00, 0, 3, 3, 0, '2026-04-18 15:18:56', '2026-04-18 15:18:56', NULL),
(1058, 1063, 7, 'AE22581', NULL, '2029-01-31', 1050.00, 1500.00, 0, 3, 2, 0, '2026-04-18 15:21:43', '2026-04-18 15:21:43', NULL),
(1059, 1064, 7, '40191002', NULL, '2029-10-31', 2980.00, 4200.00, 0, 2, 1, 0, '2026-04-18 15:24:29', '2026-04-18 15:24:29', NULL),
(1060, 818, 7, 'W25038', NULL, '2028-07-31', 1250.00, 1750.00, 0, 2, 0, 0, '2026-04-18 15:27:40', '2026-04-18 15:27:40', NULL),
(1061, 1065, 7, '04190225', NULL, '2028-02-19', 625.00, 850.00, 0, 12, 2, 0, '2026-04-18 15:31:51', '2026-04-18 15:31:51', NULL),
(1062, 1067, 7, '188L0128', NULL, '2028-10-31', 3210.00, 4500.00, 0, 2, 1, 0, '2026-04-18 15:39:31', '2026-04-18 15:39:31', NULL),
(1063, 1066, 7, '24252', NULL, '2031-12-31', 4500.00, 5900.00, 0, 1, 1, 0, '2026-04-18 15:42:54', '2026-04-18 15:55:10', NULL),
(1064, 394, 7, '251116', NULL, '2028-11-30', 270.00, 380.00, 0, 10, 0, 0, '2026-04-18 15:43:47', '2026-04-18 15:43:47', NULL),
(1065, 1068, 7, 'ENS503', NULL, '2027-12-31', 225.00, 350.00, 0, 6, 2, 0, '2026-04-18 15:50:37', '2026-04-18 15:50:37', NULL),
(1066, 1069, 7, '1568L2401', NULL, '2027-10-31', 2000.00, 2800.00, 0, 2, 1, 0, '2026-04-18 15:54:39', '2026-04-18 15:54:39', NULL),
(1067, 716, 7, 'S0518SE', NULL, '2028-03-31', 550.00, 800.00, 0, 3, 0, 0, '2026-04-18 15:58:27', '2026-04-18 15:58:27', NULL),
(1068, 1070, 7, 'I51H0327', NULL, '2027-07-31', 775.00, 1100.00, 0, 1, 1, 0, '2026-04-18 16:02:29', '2026-04-18 16:02:29', NULL),
(1069, 1071, 7, '26001', NULL, '2028-12-31', 1233.33, 1750.00, 0, 3, 3, 0, '2026-04-18 16:09:43', '2026-04-18 16:09:43', NULL),
(1070, 1073, 7, '25043', NULL, '2028-02-29', 575.00, 850.00, 0, 5, 2, 0, '2026-04-18 16:13:02', '2026-04-18 16:13:02', NULL),
(1071, 1074, 7, '2170225', NULL, '2028-05-31', 425.00, 600.00, 0, 2, 1, 0, '2026-04-18 16:15:55', '2026-04-18 16:15:55', NULL),
(1072, 1075, 7, 'GT2745', NULL, '2028-06-30', 6400.00, 9000.00, 0, 1, 1, 0, '2026-04-18 16:19:25', '2026-04-18 16:19:25', NULL),
(1073, 1076, 7, '20241230', NULL, '2029-12-29', 47.00, 100.00, 0, 100, 5, 0, '2026-04-18 16:25:30', '2026-04-18 16:25:30', NULL),
(1074, 1077, 7, '250210', NULL, '2030-02-28', 43.00, 100.00, 0, 100, 5, 0, '2026-04-18 16:29:05', '2026-04-18 16:29:05', NULL),
(1075, 1072, 7, '24203', NULL, '2031-12-30', 4500.00, 5900.00, 0, 1, 1, 0, '2026-04-18 16:29:29', '2026-04-18 16:29:29', NULL),
(1076, 1078, 7, '25J1382', NULL, '2028-10-31', 980.00, 1400.00, 0, 10, 2, 0, '2026-04-18 16:33:48', '2026-04-18 16:33:48', NULL),
(1077, 1079, 7, 'T32601', NULL, '2028-01-31', 495.00, 700.00, 0, 3, 2, 0, '2026-04-18 16:37:38', '2026-04-18 16:37:38', NULL),
(1078, 1080, 7, '250433', NULL, '2028-04-30', 740.00, 1050.00, 0, 5, 2, 0, '2026-04-18 16:40:46', '2026-04-18 16:40:46', NULL),
(1079, 1081, 7, '659241223', NULL, '2027-12-31', 1000.00, 1400.00, 0, 10, 2, 0, '2026-04-18 16:45:17', '2026-04-18 16:45:17', NULL),
(1080, 1082, 7, '794250402', NULL, '2028-04-30', 1750.00, 2450.00, 0, 2, 1, 0, '2026-04-18 16:48:14', '2026-04-18 16:48:14', NULL),
(1081, 1083, 7, 'S2520410', NULL, '2028-03-31', 1518.33, 2150.00, 0, 3, 3, 0, '2026-04-18 16:52:26', '2026-04-18 16:52:26', NULL),
(1082, 800, 7, 'CM24246', NULL, '2027-11-30', 660.00, 950.00, 0, 2, 0, 0, '2026-04-18 16:54:54', '2026-04-18 16:54:54', NULL),
(1083, 1084, 7, 'S14F', NULL, '2031-01-31', 340.00, 500.00, 0, 10, 2, 0, '2026-04-18 17:00:00', '2026-04-18 17:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `stock_movements`
--

CREATE TABLE `stock_movements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `stock_item_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `movement_type` enum('purchase','sale','transfer_in','transfer_out','adjustment','expiry','return') NOT NULL COMMENT 'Type of stock movement',
  `quantity` int(11) NOT NULL COMMENT 'Quantity moved (positive for increase, negative for decrease)',
  `unit_cost` decimal(10,2) DEFAULT NULL COMMENT 'Unit cost at time of movement',
  `reference_type` varchar(100) DEFAULT NULL COMMENT 'Polymorphic reference type',
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Polymorphic reference ID',
  `reason` text DEFAULT NULL COMMENT 'Reason for movement (required for adjustments)',
  `movement_date` date NOT NULL COMMENT 'Date of movement (allows backdating with authorization)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stock_movements`
--

INSERT INTO `stock_movements` (`id`, `stock_item_id`, `user_id`, `movement_type`, `quantity`, `unit_cost`, `reference_type`, `reference_id`, `reason`, `movement_date`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 1, 'Sale: SAL-202601000001', '2026-01-10', '2026-01-10 20:57:07', '2026-01-10 20:57:07'),
(2, 1, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 2, 'Sale: SAL-202601000002', '2026-01-10', '2026-01-10 21:13:27', '2026-01-10 21:13:27'),
(3, 1, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 3, 'Sale: SAL-202601000003', '2026-01-10', '2026-01-10 21:31:41', '2026-01-10 21:31:41'),
(4, 1, 1, 'return', 1, 2400.00, 'App\\Models\\SaleReturn', 1, 'Return: test (Authorized by admin #1)', '2026-01-10', '2026-01-10 21:57:52', '2026-01-10 21:57:52'),
(5, 1, 1, 'return', 1, 2400.00, 'App\\Models\\SaleReturn', 2, 'Return: rewer (Authorized by admin #1)', '2026-01-10', '2026-01-10 21:59:29', '2026-01-10 21:59:29'),
(6, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 4, 'Sale: SAL-202601000004', '2026-01-13', '2026-01-13 18:55:16', '2026-01-13 18:55:16'),
(7, 1, 8, 'sale', -4, NULL, 'App\\Models\\Sale', 5, 'Sale: SAL-202601000005', '2026-01-13', '2026-01-13 19:01:33', '2026-01-13 19:01:33'),
(8, 1, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 6, 'Sale: SAL-202601000006', '2026-01-13', '2026-01-13 19:14:22', '2026-01-13 19:14:22'),
(9, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 7, 'Sale: SAL-202601000007', '2026-01-13', '2026-01-13 19:25:32', '2026-01-13 19:25:32'),
(10, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 8, 'Sale: SAL-202601000008', '2026-01-13', '2026-01-13 20:10:14', '2026-01-13 20:10:14'),
(11, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 9, 'Sale: SAL-202601000009', '2026-01-13', '2026-01-13 20:49:51', '2026-01-13 20:49:51'),
(12, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 10, 'Sale: SAL-202601000010', '2026-01-13', '2026-01-13 20:51:06', '2026-01-13 20:51:06'),
(13, 1, 8, 'sale', -1, NULL, 'App\\Models\\Sale', 11, 'Sale: SAL-202601000011', '2026-01-13', '2026-01-13 21:13:10', '2026-01-13 21:13:10'),
(14, 2, 1, 'expiry', 30, 20000.00, NULL, NULL, 'Damaged', '2026-01-23', '2026-01-23 09:30:33', '2026-01-23 09:30:33'),
(15, 2, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 12, 'Sale: SAL-202601000012', '2026-01-23', '2026-01-23 09:32:18', '2026-01-23 09:32:18'),
(16, 2, 1, 'return', 1, 22000.00, 'App\\Models\\SaleReturn', 3, 'Return: Bad product (Authorized by admin #1)', '2026-01-23', '2026-01-23 09:34:56', '2026-01-23 09:34:56'),
(17, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 13, 'Sale: SAL-202601000013', '2026-01-23', '2026-01-23 10:02:28', '2026-01-23 10:02:28'),
(18, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 14, 'Sale: SAL-202601000014', '2026-01-24', '2026-01-23 23:39:49', '2026-01-23 23:39:49'),
(19, 3, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 15, 'Sale: SAL-202601000015', '2026-01-24', '2026-01-23 23:56:44', '2026-01-23 23:56:44'),
(20, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 16, 'Sale: SAL-202601000016', '2026-01-24', '2026-01-24 00:02:55', '2026-01-24 00:02:55'),
(21, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 17, 'Sale: SAL-202601000017', '2026-01-24', '2026-01-24 00:03:16', '2026-01-24 00:03:16'),
(22, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 18, 'Sale: SAL-202601000018', '2026-01-24', '2026-01-24 00:04:09', '2026-01-24 00:04:09'),
(23, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 19, 'Sale: SAL-202601000019', '2026-01-24', '2026-01-24 00:19:28', '2026-01-24 00:19:28'),
(24, 3, 9, 'sale', -1, NULL, 'App\\Models\\Sale', 20, 'Sale: SAL-202601000020', '2026-01-24', '2026-01-24 00:59:01', '2026-01-24 00:59:01'),
(25, 3, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 21, 'Sale: SAL-202601000021', '2026-01-24', '2026-01-24 01:00:18', '2026-01-24 01:00:18'),
(26, 5, 1, 'sale', -100, NULL, 'App\\Models\\Sale', 22, 'Sale: SAL-202601000022', '2026-01-24', '2026-01-24 20:12:27', '2026-01-24 20:12:27'),
(27, 5, 2, 'return', 50, 850.00, 'App\\Models\\SaleReturn', 4, 'Return: bad packaging (Authorized by admin #1)', '2026-01-24', '2026-01-24 20:56:53', '2026-01-24 20:56:53'),
(28, 5, 2, 'sale', -1, NULL, 'App\\Models\\Sale', 23, 'Sale: SAL-202601000023', '2026-01-24', '2026-01-24 21:12:22', '2026-01-24 21:12:22'),
(29, 3, 2, 'sale', -1, NULL, 'App\\Models\\Sale', 24, 'Sale: SAL-202601000024', '2026-01-25', '2026-01-24 23:30:07', '2026-01-24 23:30:07'),
(30, 5, 9, 'sale', -49, NULL, 'App\\Models\\Sale', 25, 'Sale: SAL-202601000025', '2026-01-25', '2026-01-25 12:23:07', '2026-01-25 12:23:07'),
(31, 4, 9, 'sale', -10, NULL, 'App\\Models\\Sale', 26, 'Sale: SAL-202601000026', '2026-01-25', '2026-01-25 12:27:59', '2026-01-25 12:27:59'),
(32, 3, 9, 'sale', -2, NULL, 'App\\Models\\Sale', 26, 'Sale: SAL-202601000026', '2026-01-25', '2026-01-25 12:27:59', '2026-01-25 12:27:59'),
(33, 361, 1, 'purchase', 10, 1536.60, NULL, NULL, 'Quick Add Batch: Added 10 units to existing batch CF07535', '2026-04-11', '2026-04-11 11:59:41', '2026-04-11 11:59:41'),
(34, 645, 1, 'purchase', 25, 345.68, NULL, NULL, 'Initial stock: New batch 344223', '2026-04-11', '2026-04-11 12:09:24', '2026-04-11 12:09:24'),
(35, 646, 1, 'purchase', 2, 598.00, NULL, NULL, 'Initial stock: New batch FPA150226', '2026-04-11', '2026-04-11 12:18:36', '2026-04-11 12:18:36'),
(36, 646, 1, 'purchase', 2, 598.00, NULL, NULL, 'Quick Add Batch: Added 2 units to existing batch FPA150226', '2026-04-11', '2026-04-11 12:23:25', '2026-04-11 12:23:25'),
(37, 647, 1, 'purchase', 1, 10698.00, NULL, NULL, 'Initial stock: New batch 20202719', '2026-04-11', '2026-04-11 12:36:11', '2026-04-11 12:36:11'),
(38, 648, 1, 'purchase', 10, 155.00, NULL, NULL, 'Initial stock: New batch PH07C0', '2026-04-11', '2026-04-11 12:39:33', '2026-04-11 12:39:33'),
(39, 649, 1, 'purchase', 3, 1747.67, NULL, NULL, 'Initial stock: New batch NMA25001', '2026-04-11', '2026-04-11 12:43:50', '2026-04-11 12:43:50'),
(40, 650, 1, 'purchase', 1, 4655.00, NULL, NULL, 'Initial stock: New batch L5252/3', '2026-04-11', '2026-04-11 12:47:20', '2026-04-11 12:47:20'),
(41, 651, 1, 'purchase', 2, 965.00, NULL, NULL, 'Initial stock: New batch IZM024061', '2026-04-11', '2026-04-11 12:47:33', '2026-04-11 12:47:33'),
(42, 652, 1, 'purchase', 4, 4018.00, NULL, NULL, 'Initial stock: New batch L5252/4', '2026-04-11', '2026-04-11 12:50:17', '2026-04-11 12:50:17'),
(43, 653, 1, 'purchase', 2, 1100.00, NULL, NULL, 'Initial stock: New batch IZN0225001', '2026-04-11', '2026-04-11 12:50:45', '2026-04-11 12:50:45'),
(44, 654, 1, 'purchase', 3, 1171.00, NULL, NULL, 'Initial stock: New batch 7406', '2026-04-11', '2026-04-11 12:54:46', '2026-04-11 12:54:46'),
(45, 655, 1, 'purchase', 1, 15000.00, NULL, NULL, 'Initial stock: New batch JM0492', '2026-04-11', '2026-04-11 12:56:26', '2026-04-11 12:56:26'),
(46, 656, 1, 'purchase', 160, 137.50, NULL, NULL, 'Initial stock: New batch 3666E', '2026-04-11', '2026-04-11 13:02:50', '2026-04-11 13:02:50'),
(47, 657, 1, 'purchase', 1, 10165.00, NULL, NULL, 'Initial stock: New batch LZ5098', '2026-04-11', '2026-04-11 13:04:06', '2026-04-11 13:04:06'),
(48, 658, 1, 'purchase', 3, 710.00, NULL, NULL, 'Initial stock: New batch 104F0229', '2026-04-11', '2026-04-11 13:06:23', '2026-04-11 13:06:23'),
(49, 659, 1, 'purchase', 2, 5136.00, NULL, NULL, 'Initial stock: New batch FW2402AA', '2026-04-11', '2026-04-11 13:08:10', '2026-04-11 13:08:10'),
(50, 660, 1, 'purchase', 1, 11880.00, NULL, NULL, 'Initial stock: New batch 327828A', '2026-04-11', '2026-04-11 13:13:43', '2026-04-11 13:13:43'),
(51, 661, 1, 'purchase', 2, 1600.00, NULL, NULL, 'Initial stock: New batch G251267', '2026-04-11', '2026-04-11 13:14:32', '2026-04-11 13:14:32'),
(52, 662, 1, 'purchase', 1, 12840.00, NULL, NULL, 'Initial stock: New batch 175659', '2026-04-11', '2026-04-11 13:17:58', '2026-04-11 13:17:58'),
(53, 663, 1, 'purchase', 2, 1100.00, NULL, NULL, 'Initial stock: New batch F4079', '2026-04-11', '2026-04-11 13:19:12', '2026-04-11 13:19:12'),
(54, 664, 1, 'purchase', 1, 13325.00, NULL, NULL, 'Initial stock: New batch 173449', '2026-04-11', '2026-04-11 13:22:30', '2026-04-11 13:22:30'),
(55, 665, 1, 'purchase', 2, 5350.00, NULL, NULL, 'Initial stock: New batch 25B047', '2026-04-11', '2026-04-11 14:32:16', '2026-04-11 14:32:16'),
(56, 666, 1, 'purchase', 1, 20275.00, NULL, NULL, 'Initial stock: New batch WP2513', '2026-04-11', '2026-04-11 14:32:36', '2026-04-11 14:32:36'),
(57, 667, 1, 'purchase', 1, 20972.00, NULL, NULL, 'Initial stock: New batch IE2503T', '2026-04-11', '2026-04-11 14:35:14', '2026-04-11 14:35:14'),
(58, 668, 1, 'purchase', 2, 800.00, NULL, NULL, 'Initial stock: New batch 499', '2026-04-11', '2026-04-11 14:35:20', '2026-04-11 14:35:20'),
(59, 669, 1, 'purchase', 1, 27606.00, NULL, NULL, 'Initial stock: New batch IEA2501P', '2026-04-11', '2026-04-11 14:38:11', '2026-04-11 14:38:11'),
(60, 670, 1, 'purchase', 2, 400.00, NULL, NULL, 'Initial stock: New batch L225264', '2026-04-11', '2026-04-11 14:39:59', '2026-04-11 14:39:59'),
(61, 671, 1, 'purchase', 2, 700.00, NULL, NULL, 'Initial stock: New batch L225026', '2026-04-11', '2026-04-11 14:42:20', '2026-04-11 14:42:20'),
(62, 672, 1, 'purchase', 1, 17120.00, NULL, NULL, 'Initial stock: New batch 5313126220', '2026-04-11', '2026-04-11 14:43:30', '2026-04-11 14:43:30'),
(63, 673, 1, 'purchase', 2, 800.00, NULL, NULL, 'Initial stock: New batch L225228', '2026-04-11', '2026-04-11 14:44:15', '2026-04-11 14:44:15'),
(64, 674, 1, 'purchase', 1, 10700.00, NULL, NULL, 'Initial stock: New batch 25G065', '2026-04-11', '2026-04-11 14:45:58', '2026-04-11 14:45:58'),
(65, 675, 1, 'purchase', 1, 12626.00, NULL, NULL, 'Initial stock: New batch 1225213', '2026-04-11', '2026-04-11 14:48:18', '2026-04-11 14:48:18'),
(66, 676, 1, 'purchase', 2, 6500.00, NULL, NULL, 'Initial stock: New batch A09PT8', '2026-04-11', '2026-04-11 14:48:30', '2026-04-11 14:48:30'),
(67, 677, 1, 'purchase', 1, 10379.00, NULL, NULL, 'Initial stock: New batch 0525072', '2026-04-11', '2026-04-11 14:51:45', '2026-04-11 14:51:45'),
(68, 678, 1, 'purchase', 5, 590.00, NULL, NULL, 'Initial stock: New batch 25285', '2026-04-11', '2026-04-11 14:54:29', '2026-04-11 14:54:29'),
(69, 679, 1, 'purchase', 2, 4495.00, NULL, NULL, 'Initial stock: New batch 5M053002', '2026-04-11', '2026-04-11 14:54:59', '2026-04-11 14:54:59'),
(70, 680, 1, 'purchase', 3, 640.00, NULL, NULL, 'Initial stock: New batch D025052', '2026-04-11', '2026-04-11 14:58:40', '2026-04-11 14:58:40'),
(71, 681, 1, 'purchase', 4, 499.00, NULL, NULL, 'Initial stock: New batch KPS25110', '2026-04-11', '2026-04-11 14:59:21', '2026-04-11 14:59:21'),
(72, 682, 1, 'purchase', 3, 520.00, NULL, NULL, 'Initial stock: New batch 25147', '2026-04-11', '2026-04-11 15:01:04', '2026-04-11 15:01:04'),
(73, 683, 1, 'purchase', 3, 749.00, NULL, NULL, 'Initial stock: New batch 1030825', '2026-04-11', '2026-04-11 15:03:00', '2026-04-11 15:03:00'),
(74, 684, 1, 'purchase', 1, 7319.00, NULL, NULL, 'Initial stock: New batch 2506039', '2026-04-11', '2026-04-11 15:05:43', '2026-04-11 15:05:43'),
(75, 685, 1, 'purchase', 5, 545.00, NULL, NULL, 'Initial stock: New batch 25GP0148', '2026-04-11', '2026-04-11 15:08:50', '2026-04-11 15:08:50'),
(76, 686, 1, 'purchase', 4, 1871.25, NULL, NULL, 'Initial stock: New batch 4146', '2026-04-11', '2026-04-11 15:10:42', '2026-04-11 15:10:42'),
(77, 687, 1, 'purchase', 5, 980.00, NULL, NULL, 'Initial stock: New batch 09H0429', '2026-04-11', '2026-04-11 15:11:43', '2026-04-11 15:11:43'),
(78, 688, 1, 'purchase', 3, 2833.33, NULL, NULL, 'Initial stock: New batch 25D212', '2026-04-11', '2026-04-11 15:14:27', '2026-04-11 15:14:27'),
(79, 689, 1, 'purchase', 5, 2785.00, NULL, NULL, 'Initial stock: New batch I417E5001', '2026-04-11', '2026-04-11 15:15:36', '2026-04-11 15:15:36'),
(80, 690, 1, 'purchase', 1, 6153.00, NULL, NULL, 'Initial stock: New batch M24L003', '2026-04-11', '2026-04-11 15:17:30', '2026-04-11 15:17:30'),
(81, 691, 1, 'purchase', 1, 7383.00, NULL, NULL, 'Initial stock: New batch M24L002', '2026-04-11', '2026-04-11 15:20:05', '2026-04-11 15:20:05'),
(82, 692, 1, 'purchase', 10, 113.50, NULL, NULL, 'Initial stock: New batch KP25036', '2026-04-11', '2026-04-11 15:20:17', '2026-04-11 15:20:17'),
(83, 693, 1, 'purchase', 2, 2900.00, NULL, NULL, 'Initial stock: New batch 61125006', '2026-04-11', '2026-04-11 15:23:17', '2026-04-11 15:23:17'),
(84, 694, 1, 'purchase', 2, 2460.00, NULL, NULL, 'Initial stock: New batch 5289A', '2026-04-11', '2026-04-11 15:26:48', '2026-04-11 15:26:48'),
(85, 695, 1, 'purchase', 3, 2996.00, NULL, NULL, 'Initial stock: New batch 25G11E1', '2026-04-11', '2026-04-11 15:28:01', '2026-04-11 15:28:01'),
(86, 696, 1, 'purchase', 2, 1020.00, NULL, NULL, 'Initial stock: New batch 46B0529', '2026-04-11', '2026-04-11 15:29:29', '2026-04-11 15:29:29'),
(87, 697, 1, 'purchase', 3, 3174.33, NULL, NULL, 'Initial stock: New batch 25F07C1', '2026-04-11', '2026-04-11 15:32:55', '2026-04-11 15:32:55'),
(88, 698, 1, 'purchase', 5, 185.00, NULL, NULL, 'Initial stock: New batch 55010048', '2026-04-11', '2026-04-11 15:37:08', '2026-04-11 15:37:08'),
(89, 699, 1, 'purchase', 2, 1602.00, NULL, NULL, 'Initial stock: New batch 5130506', '2026-04-11', '2026-04-11 15:41:58', '2026-04-11 15:41:58'),
(90, 700, 1, 'purchase', 3, 480.00, NULL, NULL, 'Initial stock: New batch A250379', '2026-04-11', '2026-04-11 15:43:23', '2026-04-11 15:43:23'),
(91, 701, 1, 'purchase', 3, 3317.00, NULL, NULL, 'Initial stock: New batch 2504034A', '2026-04-11', '2026-04-11 15:44:41', '2026-04-11 15:44:41'),
(92, 702, 1, 'purchase', 3, 645.00, NULL, NULL, 'Initial stock: New batch 25319', '2026-04-11', '2026-04-11 15:47:22', '2026-04-11 15:47:22'),
(93, 703, 1, 'purchase', 6, 808.33, NULL, NULL, 'Initial stock: New batch M25D013', '2026-04-11', '2026-04-11 15:50:10', '2026-04-11 15:50:10'),
(94, 704, 1, 'purchase', 200, 133.75, NULL, NULL, 'Initial stock: New batch B251731', '2026-04-11', '2026-04-11 15:50:54', '2026-04-11 15:50:54'),
(95, 705, 1, 'purchase', 1, 1100.00, NULL, NULL, 'Initial stock: New batch F4078', '2026-04-11', '2026-04-11 15:54:28', '2026-04-11 15:54:28'),
(96, 706, 1, 'purchase', 10, 500.00, NULL, NULL, 'Initial stock: New batch FD24144', '2026-04-11', '2026-04-11 15:58:11', '2026-04-11 15:58:11'),
(97, 707, 1, 'purchase', 6, 2942.50, NULL, NULL, 'Initial stock: New batch SD0052', '2026-04-11', '2026-04-11 16:01:04', '2026-04-11 16:01:04'),
(98, 708, 1, 'purchase', 5, 1070.00, NULL, NULL, 'Initial stock: New batch C0126001', '2026-04-11', '2026-04-11 16:02:46', '2026-04-11 16:02:46'),
(99, 709, 1, 'purchase', 20, 299.80, NULL, NULL, 'Initial stock: New batch 150953', '2026-04-11', '2026-04-11 16:06:21', '2026-04-11 16:06:21'),
(100, 710, 1, 'purchase', 6, 880.00, NULL, NULL, 'Initial stock: New batch 04K0129', '2026-04-11', '2026-04-11 16:07:25', '2026-04-11 16:07:25'),
(101, 711, 1, 'purchase', 1, 749.00, NULL, NULL, 'Initial stock: New batch F2725008', '2026-04-11', '2026-04-11 16:20:26', '2026-04-11 16:20:26'),
(102, 712, 1, 'purchase', 5, 1620.00, NULL, NULL, 'Initial stock: New batch 05G0229', '2026-04-11', '2026-04-11 16:21:15', '2026-04-11 16:21:15'),
(103, 713, 1, 'purchase', 2, 1690.00, NULL, NULL, 'Initial stock: New batch 18G0129', '2026-04-11', '2026-04-11 16:24:45', '2026-04-11 16:24:45'),
(104, 714, 1, 'purchase', 10, 121.00, NULL, NULL, 'Initial stock: New batch 250236', '2026-04-11', '2026-04-11 16:25:02', '2026-04-11 16:25:02'),
(105, 715, 1, 'purchase', 10, 332.90, NULL, NULL, 'Initial stock: New batch T66207', '2026-04-11', '2026-04-11 16:27:03', '2026-04-11 16:27:03'),
(106, 716, 1, 'purchase', 2, 2700.00, NULL, NULL, 'Initial stock: New batch 12M0129', '2026-04-11', '2026-04-11 16:28:39', '2026-04-11 16:28:39'),
(107, 717, 1, 'purchase', 2, 460.00, NULL, NULL, 'Initial stock: New batch MP2602', '2026-04-11', '2026-04-11 16:30:12', '2026-04-11 16:30:12'),
(108, 718, 1, 'purchase', 1, 3300.00, NULL, NULL, 'Initial stock: New batch 38', '2026-04-11', '2026-04-11 16:32:13', '2026-04-11 16:32:13'),
(109, 719, 1, 'purchase', 2, 1180.00, NULL, NULL, 'Initial stock: New batch 103G0729', '2026-04-11', '2026-04-11 16:32:16', '2026-04-11 16:32:16'),
(110, 720, 1, 'purchase', 1, 717.00, NULL, NULL, 'Initial stock: New batch 25286', '2026-04-11', '2026-04-11 16:34:55', '2026-04-11 16:34:55'),
(111, 721, 1, 'purchase', 2, 2043.00, NULL, NULL, 'Initial stock: New batch E216788', '2026-04-11', '2026-04-11 16:38:42', '2026-04-11 16:38:42'),
(112, 341, 1, 'purchase', 10, 642.00, NULL, NULL, 'Quick Add Batch: Added 10 units to existing batch 25013', '2026-04-11', '2026-04-11 16:40:38', '2026-04-11 16:40:38'),
(113, 397, 1, 'purchase', 1, 2026.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch 046', '2026-04-11', '2026-04-11 16:42:31', '2026-04-11 16:42:31'),
(114, 722, 1, 'purchase', 3, 1248.33, NULL, NULL, 'Initial stock: New batch MSNUH0003', '2026-04-11', '2026-04-11 16:46:27', '2026-04-11 16:46:27'),
(115, 723, 1, 'purchase', 6, 2309.00, NULL, NULL, 'Initial stock: New batch TR147', '2026-04-11', '2026-04-11 16:48:22', '2026-04-11 16:48:22'),
(116, 724, 1, 'purchase', 6, 2309.00, NULL, NULL, 'Initial stock: New batch TR086', '2026-04-11', '2026-04-11 16:49:35', '2026-04-11 16:49:35'),
(117, 725, 1, 'purchase', 3, 3505.00, NULL, NULL, 'Initial stock: New batch GC25057', '2026-04-11', '2026-04-11 16:55:24', '2026-04-11 16:55:24'),
(118, 726, 1, 'purchase', 2, 1100.00, NULL, NULL, 'Initial stock: New batch 11M0329', '2026-04-11', '2026-04-11 17:01:02', '2026-04-11 17:01:02'),
(119, 727, 1, 'purchase', 2, 2150.00, NULL, NULL, 'Initial stock: New batch 11K0229', '2026-04-12', '2026-04-12 07:49:26', '2026-04-12 07:49:26'),
(120, 728, 1, 'purchase', 8, 821.43, NULL, NULL, 'Initial stock: New batch N-3533', '2026-04-12', '2026-04-12 07:51:18', '2026-04-12 07:51:18'),
(121, 729, 1, 'purchase', 3, 2666.60, NULL, NULL, 'Initial stock: New batch GC25054', '2026-04-12', '2026-04-12 07:57:01', '2026-04-12 07:57:01'),
(122, 730, 1, 'purchase', 2, 760.00, NULL, NULL, 'Initial stock: New batch 50125', '2026-04-12', '2026-04-12 07:59:55', '2026-04-12 07:59:55'),
(123, 731, 1, 'purchase', 1, 4535.00, NULL, NULL, 'Initial stock: New batch QAB0900', '2026-04-12', '2026-04-12 08:03:28', '2026-04-12 08:03:28'),
(124, 732, 1, 'purchase', 2, 1662.00, NULL, NULL, 'Initial stock: New batch 32T24', '2026-04-12', '2026-04-12 08:05:12', '2026-04-12 08:05:12'),
(125, 733, 1, 'purchase', 6, 781.60, NULL, NULL, 'Initial stock: New batch I286E5020', '2026-04-12', '2026-04-12 08:08:08', '2026-04-12 08:08:08'),
(126, 734, 1, 'purchase', 10, 188.90, NULL, NULL, 'Initial stock: New batch 250308', '2026-04-12', '2026-04-12 08:10:42', '2026-04-12 08:10:42'),
(127, 735, 1, 'purchase', 1, 4377.00, NULL, NULL, 'Initial stock: New batch MHQH0021', '2026-04-12', '2026-04-12 08:14:36', '2026-04-12 08:14:36'),
(128, 736, 1, 'purchase', 5, 1550.00, NULL, NULL, 'Initial stock: New batch 25274', '2026-04-12', '2026-04-12 08:15:48', '2026-04-12 08:15:48'),
(129, 737, 1, 'purchase', 3, 1285.00, NULL, NULL, 'Initial stock: New batch 510N', '2026-04-12', '2026-04-12 08:18:08', '2026-04-12 08:18:08'),
(130, 738, 1, 'purchase', 4, 1123.50, NULL, NULL, 'Initial stock: New batch 280T16', '2026-04-12', '2026-04-12 08:19:51', '2026-04-12 08:19:51'),
(131, 739, 1, 'purchase', 5, 1740.00, NULL, NULL, 'Initial stock: New batch 2508001', '2026-04-12', '2026-04-12 08:21:47', '2026-04-12 08:21:47'),
(132, 740, 1, 'purchase', 4, 1391.00, NULL, NULL, 'Initial stock: New batch 364F13', '2026-04-12', '2026-04-12 08:23:56', '2026-04-12 08:23:56'),
(133, 741, 1, 'purchase', 3, 610.00, NULL, NULL, 'Initial stock: New batch OMWH0104', '2026-04-12', '2026-04-12 08:29:04', '2026-04-12 08:29:04'),
(134, 742, 1, 'purchase', 3, 1066.67, NULL, NULL, 'Initial stock: New batch C2-44', '2026-04-12', '2026-04-12 08:29:46', '2026-04-12 08:29:46'),
(135, 743, 1, 'purchase', 5, 355.00, NULL, NULL, 'Initial stock: New batch 25GP0166', '2026-04-12', '2026-04-12 08:33:22', '2026-04-12 08:33:22'),
(136, 744, 1, 'purchase', 2, 2565.00, NULL, NULL, 'Initial stock: New batch NOA7004', '2026-04-12', '2026-04-12 08:33:23', '2026-04-12 08:33:23'),
(137, 745, 1, 'purchase', 10, 1400.00, NULL, NULL, 'Initial stock: New batch D1AW032', '2026-04-12', '2026-04-12 08:37:04', '2026-04-12 08:37:04'),
(138, 746, 1, 'purchase', 3, 2639.33, NULL, NULL, 'Initial stock: New batch T25048', '2026-04-12', '2026-04-12 08:37:27', '2026-04-12 08:37:27'),
(139, 747, 1, 'purchase', 10, 450.00, NULL, NULL, 'Initial stock: New batch A250444', '2026-04-12', '2026-04-12 08:40:35', '2026-04-12 08:40:35'),
(140, 748, 1, 'purchase', 5, 635.00, NULL, NULL, 'Initial stock: New batch 25227', '2026-04-12', '2026-04-12 08:43:12', '2026-04-12 08:43:12'),
(141, 749, 1, 'purchase', 1, 8100.00, NULL, NULL, 'Initial stock: New batch 251120', '2026-04-12', '2026-04-12 08:46:55', '2026-04-12 08:46:55'),
(142, 750, 1, 'purchase', 10, 800.00, NULL, NULL, 'Initial stock: New batch 5H514003', '2026-04-12', '2026-04-12 08:49:45', '2026-04-12 08:49:45'),
(143, 751, 1, 'purchase', 3, 1393.33, NULL, NULL, 'Initial stock: New batch 26004', '2026-04-12', '2026-04-12 08:50:19', '2026-04-12 08:50:19'),
(144, 752, 1, 'purchase', 5, 900.00, NULL, NULL, 'Initial stock: New batch 5F508009', '2026-04-12', '2026-04-12 08:53:17', '2026-04-12 08:53:17'),
(145, 753, 1, 'purchase', 2, 589.00, NULL, NULL, 'Initial stock: New batch 06K0129', '2026-04-12', '2026-04-12 08:55:58', '2026-04-12 08:55:58'),
(146, 754, 1, 'purchase', 5, 900.00, NULL, NULL, 'Initial stock: New batch 5K452025', '2026-04-12', '2026-04-12 08:56:33', '2026-04-12 08:56:33'),
(147, 755, 1, 'purchase', 6, 480.00, NULL, NULL, 'Initial stock: New batch PCF2643', '2026-04-12', '2026-04-12 09:01:11', '2026-04-12 09:01:11'),
(148, 228, 1, 'purchase', 4, 428.00, NULL, NULL, 'Quick Add Batch: Added 4 units to existing batch F451125', '2026-04-12', '2026-04-12 09:05:11', '2026-04-12 09:05:11'),
(149, 756, 1, 'purchase', 6, 428.00, NULL, NULL, 'Initial stock: New batch F2226', '2026-04-12', '2026-04-12 09:06:52', '2026-04-12 09:06:52'),
(150, 757, 1, 'purchase', 5, 2100.00, NULL, NULL, 'Initial stock: New batch 100845', '2026-04-12', '2026-04-12 09:07:13', '2026-04-12 09:07:13'),
(151, 758, 1, 'purchase', 1, 5136.00, NULL, NULL, 'Initial stock: New batch ENL002', '2026-04-12', '2026-04-12 09:12:12', '2026-04-12 09:12:12'),
(152, 759, 1, 'purchase', 50, 58.00, NULL, NULL, 'Initial stock: New batch 250701001', '2026-04-12', '2026-04-12 09:12:56', '2026-04-12 09:12:56'),
(153, 760, 1, 'purchase', 1, 4066.00, NULL, NULL, 'Initial stock: New batch ENG035', '2026-04-12', '2026-04-12 09:16:12', '2026-04-12 09:16:12'),
(154, 761, 1, 'purchase', 2, 2477.50, NULL, NULL, 'Initial stock: New batch GC25040', '2026-04-12', '2026-04-12 09:21:40', '2026-04-12 09:21:40'),
(155, 762, 1, 'purchase', 2, 2585.00, NULL, NULL, 'Initial stock: New batch GDZ1025006', '2026-04-12', '2026-04-12 09:25:57', '2026-04-12 09:25:57'),
(156, 763, 1, 'purchase', 2, 2407.50, NULL, NULL, 'Initial stock: New batch GDY1225003', '2026-04-12', '2026-04-12 09:29:51', '2026-04-12 09:29:51'),
(157, 764, 1, 'purchase', 3, 4387.00, NULL, NULL, 'Initial stock: New batch 25E1822', '2026-04-12', '2026-04-12 09:36:11', '2026-04-12 09:36:11'),
(158, 765, 1, 'purchase', 3, 3208.33, NULL, NULL, 'Initial stock: New batch 25006', '2026-04-12', '2026-04-12 09:43:32', '2026-04-12 09:43:32'),
(159, 766, 1, 'purchase', 3, 3208.33, NULL, NULL, 'Initial stock: New batch 25006', '2026-04-12', '2026-04-12 09:46:40', '2026-04-12 09:46:40'),
(160, 767, 1, 'purchase', 4, 3370.50, NULL, NULL, 'Initial stock: New batch 25J1780', '2026-04-12', '2026-04-12 09:55:04', '2026-04-12 09:55:04'),
(161, 768, 1, 'purchase', 4, 3410.75, NULL, NULL, 'Initial stock: New batch 25I0773', '2026-04-12', '2026-04-12 09:58:31', '2026-04-12 09:58:31'),
(162, 769, 1, 'purchase', 50, 76.40, NULL, NULL, 'Initial stock: New batch NW25B13', '2026-04-12', '2026-04-12 10:04:44', '2026-04-12 10:04:44'),
(163, 770, 1, 'purchase', 5, 575.00, NULL, NULL, 'Initial stock: New batch 01M0229', '2026-04-12', '2026-04-12 10:08:31', '2026-04-12 10:08:31'),
(164, 771, 1, 'purchase', 1, 1485.00, NULL, NULL, 'Initial stock: New batch XDAH0031', '2026-04-12', '2026-04-12 10:09:51', '2026-04-12 10:09:51'),
(165, 772, 1, 'purchase', 1, 2345.00, NULL, NULL, 'Initial stock: New batch XDBH0039', '2026-04-12', '2026-04-12 10:14:01', '2026-04-12 10:14:01'),
(166, 773, 1, 'purchase', 1, 3745.00, NULL, NULL, 'Initial stock: New batch E11801', '2026-04-12', '2026-04-12 10:16:39', '2026-04-12 10:16:39'),
(167, 774, 1, 'purchase', 2, 5800.00, NULL, NULL, 'Initial stock: New batch 856E2', '2026-04-12', '2026-04-12 10:20:25', '2026-04-12 10:20:25'),
(168, 775, 1, 'purchase', 10, 645.00, NULL, NULL, 'Initial stock: New batch GT24475', '2026-04-12', '2026-04-12 10:20:42', '2026-04-12 10:20:42'),
(169, 776, 1, 'purchase', 5, 1750.00, NULL, NULL, 'Initial stock: New batch L6126', '2026-04-12', '2026-04-12 10:26:52', '2026-04-12 10:26:52'),
(170, 777, 1, 'purchase', 10, 790.00, NULL, NULL, 'Initial stock: New batch AF60507', '2026-04-12', '2026-04-12 10:27:43', '2026-04-12 10:27:43'),
(171, 778, 1, 'purchase', 2, 4387.00, NULL, NULL, 'Initial stock: New batch 01260', '2026-04-12', '2026-04-12 10:31:59', '2026-04-12 10:31:59'),
(172, 779, 1, 'purchase', 4, 1177.50, NULL, NULL, 'Initial stock: New batch L225059', '2026-04-12', '2026-04-12 10:34:48', '2026-04-12 10:34:48'),
(173, 780, 1, 'purchase', 2, 562.00, NULL, NULL, 'Initial stock: New batch F0225128', '2026-04-12', '2026-04-12 10:35:44', '2026-04-12 10:35:44'),
(174, 781, 1, 'purchase', 3, 562.00, NULL, NULL, 'Initial stock: New batch F01251088', '2026-04-12', '2026-04-12 10:39:21', '2026-04-12 10:39:21'),
(175, 782, 1, 'purchase', 5, 815.00, NULL, NULL, 'Initial stock: New batch UTGRBA501', '2026-04-12', '2026-04-12 10:40:04', '2026-04-12 10:40:04'),
(176, 783, 1, 'purchase', 3, 562.00, NULL, NULL, 'Initial stock: New batch F0426042', '2026-04-12', '2026-04-12 10:42:57', '2026-04-12 10:42:57'),
(177, 784, 1, 'purchase', 6, 650.00, NULL, NULL, 'Initial stock: New batch 25G001DH26', '2026-04-12', '2026-04-12 10:43:33', '2026-04-12 10:43:33'),
(178, 785, 1, 'purchase', 4, 850.00, NULL, NULL, 'Initial stock: New batch AE20467', '2026-04-12', '2026-04-12 10:47:12', '2026-04-12 10:47:12'),
(179, 786, 1, 'purchase', 1, 1600.00, NULL, NULL, 'Initial stock: New batch OMZ165', '2026-04-12', '2026-04-12 10:47:25', '2026-04-12 10:47:25'),
(180, 787, 1, 'purchase', 2, 805.00, NULL, NULL, 'Initial stock: New batch 1200', '2026-04-12', '2026-04-12 10:50:53', '2026-04-12 10:50:53'),
(181, 788, 1, 'purchase', 10, 535.00, NULL, NULL, 'Initial stock: New batch L223081', '2026-04-12', '2026-04-12 10:51:24', '2026-04-12 10:51:24'),
(182, 789, 1, 'purchase', 3, 1182.00, NULL, NULL, 'Initial stock: New batch 1200', '2026-04-12', '2026-04-12 10:54:22', '2026-04-12 10:54:22'),
(183, 790, 1, 'purchase', 2, 1340.00, NULL, NULL, 'Initial stock: New batch M0225047', '2026-04-12', '2026-04-12 10:54:36', '2026-04-12 10:54:36'),
(184, 791, 1, 'purchase', 10, 800.00, NULL, NULL, 'Initial stock: New batch CE06572', '2026-04-12', '2026-04-12 10:57:46', '2026-04-12 10:57:46'),
(185, 792, 1, 'purchase', 10, 176.00, NULL, NULL, 'Initial stock: New batch 1200', '2026-04-12', '2026-04-12 10:58:44', '2026-04-12 10:58:44'),
(186, 793, 1, 'purchase', 10, 378.50, NULL, NULL, 'Initial stock: New batch CE05616', '2026-04-12', '2026-04-12 11:00:24', '2026-04-12 11:00:24'),
(187, 794, 1, 'purchase', 10, 460.00, NULL, NULL, 'Initial stock: New batch CF03594', '2026-04-12', '2026-04-12 11:05:18', '2026-04-12 11:05:18'),
(188, 795, 1, 'purchase', 10, 885.00, NULL, NULL, 'Initial stock: New batch CE10592', '2026-04-12', '2026-04-12 11:05:55', '2026-04-12 11:05:55'),
(189, 796, 1, 'purchase', 10, 448.00, NULL, NULL, 'Initial stock: New batch CE05540', '2026-04-12', '2026-04-12 11:09:23', '2026-04-12 11:09:23'),
(190, 797, 1, 'purchase', 1, 6265.00, NULL, NULL, 'Initial stock: New batch C2507003', '2026-04-12', '2026-04-12 11:09:25', '2026-04-12 11:09:25'),
(191, 610, 1, 'purchase', 6, 360.00, NULL, NULL, 'Quick Add Batch: Added 6 units to existing batch 25L001TC63', '2026-04-12', '2026-04-12 11:13:57', '2026-04-12 11:13:57'),
(192, 798, 1, 'purchase', 40, 60.00, NULL, NULL, 'Initial stock: New batch 2237', '2026-04-12', '2026-04-12 11:14:14', '2026-04-12 11:14:14'),
(193, 799, 1, 'purchase', 5, 660.00, NULL, NULL, 'Initial stock: New batch CM24250', '2026-04-12', '2026-04-12 11:17:52', '2026-04-12 11:17:52'),
(194, 800, 1, 'purchase', 3, 1495.00, NULL, NULL, 'Initial stock: New batch M25I012', '2026-04-12', '2026-04-12 11:19:18', '2026-04-12 11:19:18'),
(195, 801, 1, 'purchase', 5, 645.00, NULL, NULL, 'Initial stock: New batch 03M0129', '2026-04-12', '2026-04-12 11:20:47', '2026-04-12 11:20:47'),
(196, 802, 1, 'purchase', 3, 1930.00, NULL, NULL, 'Initial stock: New batch 518W', '2026-04-12', '2026-04-12 11:25:24', '2026-04-12 11:25:24'),
(197, 803, 1, 'purchase', 3, 1460.00, NULL, NULL, 'Initial stock: New batch S25E068', '2026-04-12', '2026-04-12 11:25:29', '2026-04-12 11:25:29'),
(198, 804, 1, 'purchase', 1, 1050.00, NULL, NULL, 'Initial stock: New batch BYT072D', '2026-04-12', '2026-04-12 11:30:11', '2026-04-12 11:30:11'),
(199, 805, 1, 'purchase', 5, 690.00, NULL, NULL, 'Initial stock: New batch 502299004A', '2026-04-12', '2026-04-12 11:30:22', '2026-04-12 11:30:22'),
(200, 806, 1, 'purchase', 2, 3480.00, NULL, NULL, 'Initial stock: New batch 111336', '2026-04-12', '2026-04-12 11:34:00', '2026-04-12 11:34:00'),
(201, 807, 1, 'purchase', 5, 1280.00, NULL, NULL, 'Initial stock: New batch DRP2825001', '2026-04-12', '2026-04-12 11:34:42', '2026-04-12 11:34:42'),
(202, 808, 1, 'purchase', 2, 1310.00, NULL, NULL, 'Initial stock: New batch AS251002', '2026-04-12', '2026-04-12 11:40:11', '2026-04-12 11:40:11'),
(203, 809, 1, 'purchase', 2, 1100.00, NULL, NULL, 'Initial stock: New batch DRD004L', '2026-04-12', '2026-04-12 11:43:50', '2026-04-12 11:43:50'),
(204, 810, 1, 'purchase', 2, 4375.00, NULL, NULL, 'Initial stock: New batch 346437', '2026-04-12', '2026-04-12 11:44:09', '2026-04-12 11:44:09'),
(205, 811, 1, 'purchase', 36, 285.00, NULL, NULL, 'Initial stock: New batch M01240701', '2026-04-12', '2026-04-12 11:46:49', '2026-04-12 11:46:49'),
(206, 812, 1, 'purchase', 1, 4000.00, NULL, NULL, 'Initial stock: New batch FORCEPT141', '2026-04-12', '2026-04-12 11:47:09', '2026-04-12 11:47:09'),
(207, 813, 1, 'purchase', 24, 360.00, NULL, NULL, 'Initial stock: New batch 24N0186', '2026-04-12', '2026-04-12 11:54:45', '2026-04-12 11:54:45'),
(208, 814, 1, 'purchase', 3, 2716.60, NULL, NULL, 'Initial stock: New batch 25I30E1', '2026-04-12', '2026-04-12 11:57:56', '2026-04-12 11:57:56'),
(209, 815, 1, 'purchase', 3, 1050.00, NULL, NULL, 'Initial stock: New batch 371024', '2026-04-12', '2026-04-12 11:59:42', '2026-04-12 11:59:42'),
(210, 816, 1, 'purchase', 4, 595.00, NULL, NULL, 'Initial stock: New batch 011T425', '2026-04-12', '2026-04-12 12:04:02', '2026-04-12 12:04:02'),
(211, 817, 1, 'purchase', 1, 1230.00, NULL, NULL, 'Initial stock: New batch W12508', '2026-04-12', '2026-04-12 12:05:18', '2026-04-12 12:05:18'),
(212, 818, 1, 'purchase', 1, 1230.00, NULL, NULL, 'Initial stock: New batch W12508', '2026-04-12', '2026-04-12 12:07:17', '2026-04-12 12:07:17'),
(213, 819, 1, 'purchase', 2, 9765.00, NULL, NULL, 'Initial stock: New batch 1003080965', '2026-04-12', '2026-04-12 12:10:40', '2026-04-12 12:10:40'),
(214, 820, 1, 'purchase', 1, 19440.00, NULL, NULL, 'Initial stock: New batch 31214488', '2026-04-12', '2026-04-12 12:17:46', '2026-04-12 12:17:46'),
(215, 821, 1, 'purchase', 1000, 2.16, NULL, NULL, 'Initial stock: New batch 1456E', '2026-04-12', '2026-04-12 12:23:11', '2026-04-12 12:23:11'),
(216, 616, 1, 'purchase', 6, 1620.00, NULL, NULL, 'Quick Add Batch: Added 6 units to existing batch 60825008', '2026-04-12', '2026-04-12 12:27:32', '2026-04-12 12:27:32'),
(217, 822, 1, 'purchase', 1, 7000.00, NULL, NULL, 'Initial stock: New batch J0124', '2026-04-12', '2026-04-12 12:30:01', '2026-04-12 12:30:01'),
(218, 823, 1, 'purchase', 1, 11560.00, NULL, NULL, 'Initial stock: New batch 25/27/2001', '2026-04-12', '2026-04-12 12:34:18', '2026-04-12 12:34:18'),
(219, 824, 1, 'purchase', 2, 4490.00, NULL, NULL, 'Initial stock: New batch TD24K421-B0R', '2026-04-12', '2026-04-12 12:37:12', '2026-04-12 12:37:12'),
(220, 745, 1, 'purchase', 5, 1405.00, NULL, NULL, 'Quick Add Batch: Added 5 units to existing batch D1AW032', '2026-04-12', '2026-04-12 12:39:51', '2026-04-12 12:39:51'),
(221, 825, 1, 'purchase', 2, 1820.00, NULL, NULL, 'Initial stock: New batch SKO0145', '2026-04-12', '2026-04-12 12:41:21', '2026-04-12 12:41:21'),
(222, 826, 1, 'purchase', 2, 9765.00, NULL, NULL, 'Initial stock: New batch 1002898657', '2026-04-12', '2026-04-12 12:44:00', '2026-04-12 12:44:00'),
(223, 827, 1, 'purchase', 30, 48.30, NULL, NULL, 'Initial stock: New batch L225078', '2026-04-12', '2026-04-12 12:46:39', '2026-04-12 12:46:39'),
(224, 828, 1, 'purchase', 6, 6430.00, NULL, NULL, 'Initial stock: New batch CZ2233H3', '2026-04-12', '2026-04-12 12:47:47', '2026-04-12 12:47:47'),
(225, 829, 1, 'purchase', 2, 1190.00, NULL, NULL, 'Initial stock: New batch 121206A01CE', '2026-04-12', '2026-04-12 12:51:58', '2026-04-12 12:51:58'),
(226, 830, 1, 'purchase', 10, 1240.00, NULL, NULL, 'Initial stock: New batch 9344CBZ', '2026-04-12', '2026-04-12 12:52:50', '2026-04-12 12:52:50'),
(227, 831, 1, 'purchase', 2, 4430.00, NULL, NULL, 'Initial stock: New batch P211025', '2026-04-12', '2026-04-12 12:55:30', '2026-04-12 12:55:30'),
(228, 832, 1, 'purchase', 2, 8030.00, NULL, NULL, 'Initial stock: New batch 251024JA', '2026-04-12', '2026-04-12 12:57:00', '2026-04-12 12:57:00'),
(229, 833, 1, 'purchase', 10, 650.00, NULL, NULL, 'Initial stock: New batch CF06603', '2026-04-12', '2026-04-12 12:59:07', '2026-04-12 12:59:07'),
(230, 834, 1, 'purchase', 6, 6375.00, NULL, NULL, 'Initial stock: New batch TT5231Z', '2026-04-12', '2026-04-12 12:59:27', '2026-04-12 12:59:27'),
(231, 835, 1, 'purchase', 1, 5140.00, NULL, NULL, 'Initial stock: New batch BTMT0126', '2026-04-12', '2026-04-12 13:02:36', '2026-04-12 13:02:36'),
(232, 836, 1, 'purchase', 2, 5195.00, NULL, NULL, 'Initial stock: New batch 1002624005', '2026-04-12', '2026-04-12 13:03:21', '2026-04-12 13:03:21'),
(233, 837, 1, 'purchase', 6, 6050.00, NULL, NULL, 'Initial stock: New batch KT4222530', '2026-04-12', '2026-04-12 13:06:37', '2026-04-12 13:06:37'),
(234, 838, 1, 'purchase', 1, 26380.00, NULL, NULL, 'Initial stock: New batch 2508128', '2026-04-12', '2026-04-12 13:09:42', '2026-04-12 13:09:42'),
(235, 839, 1, 'purchase', 3, 650.00, NULL, NULL, 'Initial stock: New batch L503D', '2026-04-12', '2026-04-12 13:10:53', '2026-04-12 13:10:53'),
(236, 840, 1, 'purchase', 1, 11200.00, NULL, NULL, 'Initial stock: New batch 30808J', '2026-04-12', '2026-04-12 13:12:27', '2026-04-12 13:12:27'),
(237, 841, 1, 'purchase', 1, 11560.00, NULL, NULL, 'Initial stock: New batch 2WM2890KA592', '2026-04-12', '2026-04-12 13:16:55', '2026-04-12 13:16:55'),
(238, 842, 1, 'purchase', 3, 3243.30, NULL, NULL, 'Initial stock: New batch 25D21F1', '2026-04-12', '2026-04-12 13:17:27', '2026-04-12 13:17:27'),
(239, 843, 1, 'purchase', 12, 2340.00, NULL, NULL, 'Initial stock: New batch 34', '2026-04-12', '2026-04-12 13:20:36', '2026-04-12 13:20:36'),
(240, 844, 1, 'purchase', 5, 4100.00, NULL, NULL, 'Initial stock: New batch NR02217A', '2026-04-12', '2026-04-12 13:22:17', '2026-04-12 13:22:17'),
(241, 845, 1, 'purchase', 2, 9948.84, NULL, NULL, 'Initial stock: New batch 5101450', '2026-04-12', '2026-04-12 13:25:16', '2026-04-12 13:25:16'),
(242, 846, 1, 'purchase', 2, 1100.00, NULL, NULL, 'Initial stock: New batch 41T12', '2026-04-12', '2026-04-12 13:27:03', '2026-04-12 13:27:03'),
(243, 847, 1, 'purchase', 2, 3745.00, NULL, NULL, 'Initial stock: New batch 1002714913', '2026-04-12', '2026-04-12 13:28:12', '2026-04-12 13:28:12'),
(244, 848, 1, 'purchase', 2, 2890.00, NULL, NULL, 'Initial stock: New batch 23F2514', '2026-04-12', '2026-04-12 13:31:19', '2026-04-12 13:31:19'),
(245, 849, 1, 'purchase', 3, 2833.30, NULL, NULL, 'Initial stock: New batch GC25049', '2026-04-12', '2026-04-12 13:36:02', '2026-04-12 13:36:02'),
(246, 731, 1, 'purchase', 1, 4480.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch QAB0900', '2026-04-12', '2026-04-12 13:40:21', '2026-04-12 13:40:21'),
(247, 850, 1, 'purchase', 2, 4305.00, NULL, NULL, 'Initial stock: New batch 1002539827', '2026-04-12', '2026-04-12 13:43:40', '2026-04-12 13:43:40'),
(248, 851, 1, 'purchase', 2, 6120.00, NULL, NULL, 'Initial stock: New batch 1293197', '2026-04-12', '2026-04-12 13:44:26', '2026-04-12 13:44:26'),
(249, 852, 1, 'purchase', 2, 3655.00, NULL, NULL, 'Initial stock: New batch 1002705196', '2026-04-12', '2026-04-12 13:46:17', '2026-04-12 13:46:17'),
(250, 853, 1, 'purchase', 2, 1440.00, NULL, NULL, 'Initial stock: New batch M50909', '2026-04-12', '2026-04-12 13:48:06', '2026-04-12 13:48:06'),
(251, 854, 1, 'purchase', 3, 380.00, NULL, NULL, 'Initial stock: New batch WG24590', '2026-04-12', '2026-04-12 13:50:34', '2026-04-12 13:50:34'),
(252, 855, 1, 'purchase', 2, 10170.00, NULL, NULL, 'Initial stock: New batch ECSY0065', '2026-04-12', '2026-04-12 13:52:15', '2026-04-12 13:52:15'),
(253, 856, 1, 'purchase', 1, 7020.00, NULL, NULL, 'Initial stock: New batch BABAF', '2026-04-12', '2026-04-12 13:54:06', '2026-04-12 13:54:06'),
(254, 857, 1, 'purchase', 2, 10080.00, NULL, NULL, 'Initial stock: New batch ED826', '2026-04-12', '2026-04-12 13:55:09', '2026-04-12 13:55:09'),
(255, 858, 1, 'purchase', 2, 2270.00, NULL, NULL, 'Initial stock: New batch 027T433', '2026-04-12', '2026-04-12 13:58:22', '2026-04-12 13:58:22'),
(256, 859, 1, 'purchase', 10, 500.00, NULL, NULL, 'Initial stock: New batch BL4003', '2026-04-12', '2026-04-12 13:58:47', '2026-04-12 13:58:47'),
(257, 860, 1, 'purchase', 3, 620.00, NULL, NULL, 'Initial stock: New batch 25K002DH42', '2026-04-12', '2026-04-12 14:02:01', '2026-04-12 14:02:01'),
(258, 861, 1, 'purchase', 2, 5175.00, NULL, NULL, 'Initial stock: New batch VE8T', '2026-04-12', '2026-04-12 14:02:39', '2026-04-12 14:02:39'),
(259, 862, 1, 'purchase', 6, 650.00, NULL, NULL, 'Initial stock: New batch 1250801', '2026-04-12', '2026-04-12 14:05:49', '2026-04-12 14:05:49'),
(260, 863, 1, 'purchase', 1, 2300.00, NULL, NULL, 'Initial stock: New batch A433', '2026-04-12', '2026-04-12 14:05:55', '2026-04-12 14:05:55'),
(261, 864, 1, 'purchase', 2, 15100.00, NULL, NULL, 'Initial stock: New batch WE167S', '2026-04-12', '2026-04-12 14:09:43', '2026-04-12 14:09:43'),
(262, 865, 1, 'purchase', 1, 17250.00, NULL, NULL, 'Initial stock: New batch 162510', '2026-04-12', '2026-04-12 14:13:34', '2026-04-12 14:13:34'),
(263, 866, 1, 'purchase', 6, 1570.00, NULL, NULL, 'Initial stock: New batch P793', '2026-04-12', '2026-04-12 14:30:07', '2026-04-12 14:30:07'),
(264, 867, 1, 'purchase', 1, 20900.00, NULL, NULL, 'Initial stock: New batch FIRST AID', '2026-04-12', '2026-04-12 14:38:09', '2026-04-12 14:38:09'),
(265, 773, 1, 'purchase', 1, 3745.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch E11801', '2026-04-12', '2026-04-12 14:40:49', '2026-04-12 14:40:49'),
(266, 868, 1, 'purchase', 1, 3850.00, NULL, NULL, 'Initial stock: New batch EE5030', '2026-04-12', '2026-04-12 14:41:17', '2026-04-12 14:41:17'),
(267, 869, 1, 'purchase', 1, 3150.00, NULL, NULL, 'Initial stock: New batch 25', '2026-04-12', '2026-04-12 14:46:06', '2026-04-12 14:46:06'),
(268, 870, 1, 'purchase', 12, 840.00, NULL, NULL, 'Initial stock: New batch A80126J', '2026-04-12', '2026-04-12 14:47:19', '2026-04-12 14:47:19'),
(269, 871, 1, 'purchase', 6, 1900.00, NULL, NULL, 'Initial stock: New batch 1855E03', '2026-04-12', '2026-04-12 14:50:06', '2026-04-12 14:50:06'),
(270, 872, 1, 'purchase', 1, 13380.00, NULL, NULL, 'Initial stock: New batch 29531834', '2026-04-12', '2026-04-12 14:50:56', '2026-04-12 14:50:56'),
(271, 873, 1, 'purchase', 1, 8030.00, NULL, NULL, 'Initial stock: New batch CAY0062', '2026-04-12', '2026-04-12 14:53:38', '2026-04-12 14:53:38'),
(272, 874, 1, 'purchase', 2, 1800.00, NULL, NULL, 'Initial stock: New batch 2391', '2026-04-12', '2026-04-12 14:54:42', '2026-04-12 14:54:42'),
(273, 875, 1, 'purchase', 10, 254.00, NULL, NULL, 'Initial stock: New batch 1224FD', '2026-04-12', '2026-04-12 14:58:17', '2026-04-12 14:58:17'),
(274, 876, 1, 'purchase', 10, 310.00, NULL, NULL, 'Initial stock: New batch VGT250097', '2026-04-12', '2026-04-12 15:01:33', '2026-04-12 15:01:33'),
(275, 146, 1, 'purchase', 1, 14300.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch 17516120312025', '2026-04-12', '2026-04-12 15:02:03', '2026-04-12 15:02:03'),
(276, 877, 1, 'purchase', 10, 230.00, NULL, NULL, 'Initial stock: New batch VGT250074', '2026-04-12', '2026-04-12 15:03:55', '2026-04-12 15:03:55'),
(277, 878, 1, 'purchase', 1, 9695.00, NULL, NULL, 'Initial stock: New batch 2501272', '2026-04-12', '2026-04-12 15:05:56', '2026-04-12 15:05:56'),
(278, 879, 1, 'purchase', 50, 340.00, NULL, NULL, 'Initial stock: New batch GS0226008', '2026-04-12', '2026-04-12 15:07:24', '2026-04-12 15:07:24'),
(279, 880, 1, 'purchase', 1, 9100.00, NULL, NULL, 'Initial stock: New batch 25206GI', '2026-04-12', '2026-04-12 15:13:11', '2026-04-12 15:13:11'),
(280, 881, 1, 'purchase', 5, 6000.00, NULL, NULL, 'Initial stock: New batch 25H05J2', '2026-04-12', '2026-04-12 15:14:44', '2026-04-12 15:14:44'),
(281, 882, 1, 'purchase', 1, 12450.00, NULL, NULL, 'Initial stock: New batch 25240LMS', '2026-04-12', '2026-04-12 15:15:24', '2026-04-12 15:15:24'),
(282, 883, 1, 'purchase', 2, 2100.00, NULL, NULL, 'Initial stock: New batch CE12056', '2026-04-12', '2026-04-12 15:19:07', '2026-04-12 15:19:07'),
(283, 884, 1, 'purchase', 3, 5248.30, NULL, NULL, 'Initial stock: New batch 9YD9', '2026-04-12', '2026-04-12 15:20:58', '2026-04-12 15:20:58'),
(284, 885, 1, 'purchase', 1, 9110.00, NULL, NULL, 'Initial stock: New batch 2501274', '2026-04-12', '2026-04-12 15:21:40', '2026-04-12 15:21:40'),
(285, 403, 1, 'purchase', 2, 750.00, NULL, NULL, 'Quick Add Batch: Added 2 units to existing batch PH6751', '2026-04-12', '2026-04-12 15:22:51', '2026-04-12 15:22:51'),
(286, 886, 1, 'purchase', 2, 1000.00, NULL, NULL, 'Initial stock: New batch PW2756', '2026-04-12', '2026-04-12 15:25:25', '2026-04-12 15:25:25'),
(287, 607, 1, 'purchase', 1, 9240.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch 2503031', '2026-04-12', '2026-04-12 15:27:17', '2026-04-12 15:27:17'),
(288, 887, 1, 'purchase', 2, 900.00, NULL, NULL, 'Initial stock: New batch PV5861', '2026-04-12', '2026-04-12 15:28:31', '2026-04-12 15:28:31'),
(289, 888, 1, 'purchase', 1, 10915.00, NULL, NULL, 'Initial stock: New batch 2412213', '2026-04-12', '2026-04-12 15:29:42', '2026-04-12 15:29:42'),
(290, 889, 1, 'purchase', 1, 10060.00, NULL, NULL, 'Initial stock: New batch 2412162', '2026-04-12', '2026-04-12 15:32:33', '2026-04-12 15:32:33'),
(291, 890, 1, 'purchase', 1000, 4.20, NULL, NULL, 'Initial stock: New batch 3238E', '2026-04-12', '2026-04-12 15:33:07', '2026-04-12 15:33:07'),
(292, 891, 1, 'purchase', 1, 9900.00, NULL, NULL, 'Initial stock: New batch 2501262', '2026-04-12', '2026-04-12 15:36:15', '2026-04-12 15:36:15'),
(293, 892, 1, 'purchase', 3, 4180.00, NULL, NULL, 'Initial stock: New batch 2511029', '2026-04-12', '2026-04-12 15:38:24', '2026-04-12 15:38:24'),
(294, 893, 1, 'purchase', 1, 11860.00, NULL, NULL, 'Initial stock: New batch 2501263', '2026-04-12', '2026-04-12 15:38:31', '2026-04-12 15:38:31'),
(295, 894, 1, 'purchase', 1, 20100.00, NULL, NULL, 'Initial stock: New batch C522503011', '2026-04-12', '2026-04-12 15:41:54', '2026-04-12 15:41:54'),
(296, 895, 1, 'purchase', 60, 333.30, NULL, NULL, 'Initial stock: New batch 856478581', '2026-04-12', '2026-04-12 15:43:18', '2026-04-12 15:43:18'),
(297, 896, 1, 'purchase', 30, 353.33, NULL, NULL, 'Initial stock: New batch AMPA5EY', '2026-04-12', '2026-04-12 15:46:25', '2026-04-12 15:46:25'),
(298, 897, 1, 'purchase', 1, 9375.00, NULL, NULL, 'Initial stock: New batch 2412164', '2026-04-12', '2026-04-12 15:46:47', '2026-04-12 15:46:47'),
(299, 898, 1, 'purchase', 10, 4260.00, NULL, NULL, 'Initial stock: New batch B725025A', '2026-04-12', '2026-04-12 15:51:42', '2026-04-12 15:51:42'),
(300, 899, 1, 'purchase', 1, 16585.00, NULL, NULL, 'Initial stock: New batch 593570', '2026-04-12', '2026-04-12 15:52:32', '2026-04-12 15:52:32'),
(301, 900, 1, 'purchase', 10, 3500.00, NULL, NULL, 'Initial stock: New batch CN25023', '2026-04-12', '2026-04-12 15:54:36', '2026-04-12 15:54:36'),
(302, 901, 1, 'purchase', 1, 3300.00, NULL, NULL, 'Initial stock: New batch LAUP5-23', '2026-04-12', '2026-04-12 15:58:25', '2026-04-12 15:58:25'),
(303, 902, 1, 'purchase', 3, 980.00, NULL, NULL, 'Initial stock: New batch COG016L', '2026-04-12', '2026-04-12 15:58:57', '2026-04-12 15:58:57'),
(304, 903, 1, 'purchase', 1, 14500.00, NULL, NULL, 'Initial stock: New batch 729640', '2026-04-12', '2026-04-12 16:02:50', '2026-04-12 16:02:50'),
(305, 904, 1, 'purchase', 3, 4250.00, NULL, NULL, 'Initial stock: New batch DZBHH0079', '2026-04-12', '2026-04-12 16:04:22', '2026-04-12 16:04:22'),
(306, 905, 1, 'purchase', 3, 3206.60, NULL, NULL, 'Initial stock: New batch DZAHH0022', '2026-04-12', '2026-04-12 16:07:38', '2026-04-12 16:07:38'),
(307, 906, 1, 'purchase', 6, 1500.00, NULL, NULL, 'Initial stock: New batch AGH7561', '2026-04-12', '2026-04-12 16:10:03', '2026-04-12 16:10:03'),
(308, 907, 1, 'purchase', 100, 51.40, NULL, NULL, 'Initial stock: New batch L225041', '2026-04-12', '2026-04-12 16:13:59', '2026-04-12 16:13:59'),
(309, 908, 1, 'purchase', 2, 700.00, NULL, NULL, 'Initial stock: New batch DVD006L', '2026-04-12', '2026-04-12 16:21:56', '2026-04-12 16:21:56'),
(310, 909, 1, 'purchase', 4, 530.00, NULL, NULL, 'Initial stock: New batch CDe85', '2026-04-12', '2026-04-12 16:25:33', '2026-04-12 16:25:33'),
(311, 910, 1, 'purchase', 1, 8560.00, NULL, NULL, 'Initial stock: New batch LAAD11-50', '2026-04-12', '2026-04-12 16:31:32', '2026-04-12 16:31:32'),
(312, 911, 1, 'purchase', 1, 8560.00, NULL, NULL, 'Initial stock: New batch LAAD9-52', '2026-04-12', '2026-04-12 16:34:35', '2026-04-12 16:34:35'),
(313, 912, 1, 'purchase', 1, 8640.00, NULL, NULL, 'Initial stock: New batch LAAD8-11', '2026-04-12', '2026-04-12 16:36:39', '2026-04-12 16:36:39'),
(314, 913, 1, 'purchase', 1, 7580.00, NULL, NULL, 'Initial stock: New batch LAAPUD10-3', '2026-04-12', '2026-04-12 16:40:33', '2026-04-12 16:40:33'),
(315, 914, 1, 'purchase', 12, 2335.00, NULL, NULL, 'Initial stock: New batch 1270425', '2026-04-13', '2026-04-13 10:36:49', '2026-04-13 10:36:49'),
(316, 915, 1, 'purchase', 3, 2700.00, NULL, NULL, 'Initial stock: New batch 5199834761', '2026-04-13', '2026-04-13 10:58:22', '2026-04-13 10:58:22'),
(317, 916, 1, 'purchase', 12, 383.00, NULL, NULL, 'Initial stock: New batch FL23', '2026-04-13', '2026-04-13 11:03:37', '2026-04-13 11:03:37'),
(318, 917, 1, 'purchase', 12, 791.00, NULL, NULL, 'Initial stock: New batch 05/2025', '2026-04-13', '2026-04-13 11:07:39', '2026-04-13 11:07:39'),
(319, 918, 1, 'purchase', 12, 333.00, NULL, NULL, 'Initial stock: New batch 056', '2026-04-13', '2026-04-13 11:13:23', '2026-04-13 11:13:23'),
(320, 919, 1, 'purchase', 12, 333.00, NULL, NULL, 'Initial stock: New batch 011', '2026-04-13', '2026-04-13 11:15:53', '2026-04-13 11:15:53'),
(321, 920, 1, 'purchase', 6, 1083.00, NULL, NULL, 'Initial stock: New batch 0311', '2026-04-13', '2026-04-13 11:19:06', '2026-04-13 11:19:06'),
(322, 921, 1, 'purchase', 2, 1081.00, NULL, NULL, 'Initial stock: New batch 2001', '2026-04-13', '2026-04-13 11:21:58', '2026-04-13 11:21:58'),
(323, 922, 1, 'purchase', 2, 1083.00, NULL, NULL, 'Initial stock: New batch 0202', '2026-04-13', '2026-04-13 11:27:41', '2026-04-13 11:27:41'),
(324, 923, 1, 'purchase', 50, 154.00, NULL, NULL, 'Initial stock: New batch A8', '2026-04-13', '2026-04-13 11:34:59', '2026-04-13 11:34:59'),
(325, 924, 1, 'purchase', 5, 1000.00, NULL, NULL, 'Initial stock: New batch NG02', '2026-04-13', '2026-04-13 11:43:10', '2026-04-13 11:43:10'),
(326, 925, 1, 'purchase', 5, 1000.00, NULL, NULL, 'Initial stock: New batch NG4', '2026-04-13', '2026-04-13 11:46:14', '2026-04-13 11:46:14'),
(327, 926, 1, 'purchase', 1, 5500.00, NULL, NULL, 'Initial stock: New batch NG4ZP', '2026-04-13', '2026-04-13 11:50:29', '2026-04-13 11:50:29'),
(328, 927, 1, 'purchase', 1, 5500.00, NULL, NULL, 'Initial stock: New batch NG6ZP', '2026-04-13', '2026-04-13 11:53:27', '2026-04-13 11:53:27'),
(329, 928, 1, 'purchase', 1, 5500.00, NULL, NULL, 'Initial stock: New batch NG7ZP', '2026-04-13', '2026-04-13 11:57:00', '2026-04-13 11:57:00'),
(330, 929, 1, 'purchase', 2, 5650.00, NULL, NULL, 'Initial stock: New batch N11', '2026-04-13', '2026-04-13 12:10:34', '2026-04-13 12:10:34'),
(331, 930, 1, 'purchase', 1, 5650.00, NULL, NULL, 'Initial stock: New batch N11', '2026-04-13', '2026-04-13 12:13:26', '2026-04-13 12:13:26'),
(332, 931, 1, 'purchase', 1, 5650.00, NULL, NULL, 'Initial stock: New batch N7', '2026-04-13', '2026-04-13 12:17:59', '2026-04-13 12:17:59'),
(333, 71, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 27, 'Sale: SAL-202604000001', '2026-04-14', '2026-04-14 12:25:23', '2026-04-14 12:25:23'),
(334, 57, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 27, 'Sale: SAL-202604000001', '2026-04-14', '2026-04-14 12:25:23', '2026-04-14 12:25:23'),
(335, 443, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 28, 'Sale: SAL-202604000002', '2026-04-14', '2026-04-14 12:42:22', '2026-04-14 12:42:22'),
(336, 491, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 28, 'Sale: SAL-202604000002', '2026-04-14', '2026-04-14 12:42:22', '2026-04-14 12:42:22'),
(337, 497, 1, 'sale', -5, NULL, 'App\\Models\\Sale', 29, 'Sale: SAL-202604000003', '2026-04-14', '2026-04-14 14:57:32', '2026-04-14 14:57:32'),
(338, 530, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 29, 'Sale: SAL-202604000003', '2026-04-14', '2026-04-14 14:57:32', '2026-04-14 14:57:32'),
(339, 932, 1, 'purchase', 10, 1155.00, NULL, NULL, 'Initial stock: New batch 25F077', '2026-04-15', '2026-04-15 13:43:47', '2026-04-15 13:43:47'),
(340, 933, 1, 'purchase', 5, 965.00, NULL, NULL, 'Initial stock: New batch 25ZB05', '2026-04-15', '2026-04-15 13:53:20', '2026-04-15 13:53:20'),
(341, 934, 1, 'purchase', 3, 770.00, NULL, NULL, 'Initial stock: New batch L1026002', '2026-04-15', '2026-04-15 14:11:04', '2026-04-15 14:11:04'),
(342, 935, 1, 'purchase', 3, 1530.00, NULL, NULL, 'Initial stock: New batch TMTP0037', '2026-04-15', '2026-04-15 14:23:54', '2026-04-15 14:23:54'),
(343, 936, 1, 'purchase', 3, 1783.33, NULL, NULL, 'Initial stock: New batch EL0225', '2026-04-15', '2026-04-15 14:29:05', '2026-04-15 14:29:05');
INSERT INTO `stock_movements` (`id`, `stock_item_id`, `user_id`, `movement_type`, `quantity`, `unit_cost`, `reference_type`, `reference_id`, `reason`, `movement_date`, `created_at`, `updated_at`) VALUES
(344, 937, 1, 'purchase', 3, 1900.00, NULL, NULL, 'Initial stock: New batch TVTP0047', '2026-04-15', '2026-04-15 14:33:38', '2026-04-15 14:33:38'),
(345, 938, 1, 'purchase', 1, 12000.00, NULL, NULL, 'Initial stock: New batch WE2505TA', '2026-04-15', '2026-04-15 14:40:08', '2026-04-15 14:40:08'),
(346, 939, 1, 'purchase', 3, 1333.33, NULL, NULL, 'Initial stock: New batch 2511012A', '2026-04-15', '2026-04-15 14:54:40', '2026-04-15 14:54:40'),
(347, 301, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 30, 'Sale: SAL-202604000004', '2026-04-15', '2026-04-15 14:58:19', '2026-04-15 14:58:19'),
(348, 54, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 30, 'Sale: SAL-202604000004', '2026-04-15', '2026-04-15 14:58:19', '2026-04-15 14:58:19'),
(349, 940, 1, 'purchase', 3, 2496.67, NULL, NULL, 'Initial stock: New batch TAMS56002', '2026-04-17', '2026-04-17 08:15:36', '2026-04-17 08:15:36'),
(350, 941, 1, 'purchase', 100, 47.00, NULL, NULL, 'Initial stock: New batch 240820', '2026-04-17', '2026-04-17 08:28:17', '2026-04-17 08:28:17'),
(351, 942, 1, 'purchase', 1, 3530.00, NULL, NULL, 'Initial stock: New batch 2601A', '2026-04-17', '2026-04-17 08:36:51', '2026-04-17 08:36:51'),
(352, 943, 1, 'purchase', 1, 6600.00, NULL, NULL, 'Initial stock: New batch OHH25031', '2026-04-17', '2026-04-17 08:41:38', '2026-04-17 08:41:38'),
(353, 944, 1, 'purchase', 10, 380.00, NULL, NULL, 'Initial stock: New batch 250602', '2026-04-17', '2026-04-17 08:47:30', '2026-04-17 08:47:30'),
(354, 945, 1, 'purchase', 1, 12200.00, NULL, NULL, 'Initial stock: New batch 25k005', '2026-04-17', '2026-04-17 08:53:07', '2026-04-17 08:53:07'),
(355, 946, 1, 'purchase', 10, 400.00, NULL, NULL, 'Initial stock: New batch T1ABG027', '2026-04-17', '2026-04-17 09:13:17', '2026-04-17 09:13:17'),
(356, 947, 1, 'purchase', 1, 4815.00, NULL, NULL, 'Initial stock: New batch 0027', '2026-04-17', '2026-04-17 09:19:45', '2026-04-17 09:19:45'),
(357, 948, 1, 'purchase', 2, 730.00, NULL, NULL, 'Initial stock: New batch A404', '2026-04-17', '2026-04-17 09:30:12', '2026-04-17 09:30:12'),
(358, 949, 1, 'purchase', 2, 3500.00, NULL, NULL, 'Initial stock: New batch AJ111(01)', '2026-04-17', '2026-04-17 09:37:19', '2026-04-17 09:37:19'),
(359, 950, 1, 'purchase', 14, 1321.43, NULL, NULL, 'Initial stock: New batch KT1752', '2026-04-17', '2026-04-17 09:39:16', '2026-04-17 09:39:16'),
(360, 951, 1, 'purchase', 3, 3500.00, NULL, NULL, 'Initial stock: New batch KLM/6665', '2026-04-17', '2026-04-17 09:40:33', '2026-04-17 09:40:33'),
(361, 952, 1, 'purchase', 6, 2300.00, NULL, NULL, 'Initial stock: New batch E16P025013', '2026-04-17', '2026-04-17 09:45:45', '2026-04-17 09:45:45'),
(362, 953, 1, 'purchase', 2, 7000.00, NULL, NULL, 'Initial stock: New batch KIL716', '2026-04-17', '2026-04-17 09:48:16', '2026-04-17 09:48:16'),
(363, 954, 1, 'purchase', 5, 280.00, NULL, NULL, 'Initial stock: New batch 23041', '2026-04-17', '2026-04-17 09:49:44', '2026-04-17 09:49:44'),
(364, 955, 1, 'purchase', 2, 3700.00, NULL, NULL, 'Initial stock: New batch 798304167078', '2026-04-17', '2026-04-17 09:53:35', '2026-04-17 09:53:35'),
(365, 956, 1, 'purchase', 3, 1063.33, NULL, NULL, 'Initial stock: New batch ACNH0024', '2026-04-17', '2026-04-17 10:01:54', '2026-04-17 10:01:54'),
(366, 957, 1, 'purchase', 28, 185.00, NULL, NULL, 'Initial stock: New batch 234', '2026-04-17', '2026-04-17 10:06:48', '2026-04-17 10:06:48'),
(367, 958, 1, 'purchase', 2, 570.00, NULL, NULL, 'Initial stock: New batch YP260103', '2026-04-17', '2026-04-17 10:07:48', '2026-04-17 10:07:48'),
(368, 959, 1, 'purchase', 24, 500.00, NULL, NULL, 'Initial stock: New batch 2050226C26', '2026-04-17', '2026-04-17 10:11:42', '2026-04-17 10:11:42'),
(369, 960, 1, 'purchase', 6, 1300.00, NULL, NULL, 'Initial stock: New batch E16PN26003', '2026-04-17', '2026-04-17 10:11:50', '2026-04-17 10:11:50'),
(370, 961, 1, 'purchase', 5, 1300.00, NULL, NULL, 'Initial stock: New batch CHI212', '2026-04-17', '2026-04-17 10:15:35', '2026-04-17 10:15:35'),
(371, 962, 1, 'purchase', 1, 8000.00, NULL, NULL, 'Initial stock: New batch DFG2350A', '2026-04-17', '2026-04-17 10:17:27', '2026-04-17 10:17:27'),
(372, 963, 1, 'purchase', 10, 180.00, NULL, NULL, 'Initial stock: New batch 241515', '2026-04-17', '2026-04-17 10:21:16', '2026-04-17 10:21:16'),
(373, 964, 1, 'purchase', 2, 10500.00, NULL, NULL, 'Initial stock: New batch 233373', '2026-04-17', '2026-04-17 10:38:53', '2026-04-17 10:38:53'),
(374, 965, 1, 'purchase', 3, 2133.33, NULL, NULL, 'Initial stock: New batch 6IID004', '2026-04-17', '2026-04-17 10:47:15', '2026-04-17 10:47:15'),
(375, 966, 1, 'purchase', 1, 10700.00, NULL, NULL, 'Initial stock: New batch E8WR1A', '2026-04-17', '2026-04-17 10:52:48', '2026-04-17 10:52:48'),
(376, 967, 1, 'purchase', 24, 500.00, NULL, NULL, 'Initial stock: New batch ASP0226', '2026-04-17', '2026-04-17 10:54:50', '2026-04-17 10:54:50'),
(377, 968, 1, 'purchase', 10, 104.00, NULL, NULL, 'Initial stock: New batch 0266', '2026-04-17', '2026-04-17 10:58:49', '2026-04-17 10:58:49'),
(378, 969, 1, 'purchase', 12, 625.00, NULL, NULL, 'Initial stock: New batch ASP0226', '2026-04-17', '2026-04-17 10:59:22', '2026-04-17 10:59:22'),
(379, 970, 1, 'purchase', 12, 715.00, NULL, NULL, 'Initial stock: New batch FC5510', '2026-04-17', '2026-04-17 11:03:34', '2026-04-17 11:03:34'),
(380, 971, 1, 'purchase', 12, 2833.00, NULL, NULL, 'Initial stock: New batch 01026N', '2026-04-17', '2026-04-17 13:06:17', '2026-04-17 13:06:17'),
(381, 972, 1, 'purchase', 3, 9667.00, NULL, NULL, 'Initial stock: New batch 02726N', '2026-04-17', '2026-04-17 13:13:05', '2026-04-17 13:13:05'),
(382, 973, 1, 'purchase', 6, 1875.00, NULL, NULL, 'Initial stock: New batch 2411391616', '2026-04-17', '2026-04-17 13:14:02', '2026-04-17 13:14:02'),
(383, 974, 1, 'purchase', 3, 2140.00, NULL, NULL, 'Initial stock: New batch EM4014', '2026-04-17', '2026-04-17 13:38:02', '2026-04-17 13:38:02'),
(384, 975, 1, 'purchase', 60, 166.67, NULL, NULL, 'Initial stock: New batch MT7412', '2026-04-17', '2026-04-17 14:06:37', '2026-04-17 14:06:37'),
(385, 976, 1, 'purchase', 4, 1550.00, NULL, NULL, 'Initial stock: New batch S25F057', '2026-04-17', '2026-04-17 14:30:39', '2026-04-17 14:30:39'),
(386, 977, 1, 'purchase', 6, 350.00, NULL, NULL, 'Initial stock: New batch 12/10/15', '2026-04-18', '2026-04-18 08:51:46', '2026-04-18 08:51:46'),
(387, 977, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 31, 'Sale: SAL-202604000005', '2026-04-18', '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(388, 502, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 31, 'Sale: SAL-202604000005', '2026-04-18', '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(389, 799, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 31, 'Sale: SAL-202604000005', '2026-04-18', '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(390, 542, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 31, 'Sale: SAL-202604000005', '2026-04-18', '2026-04-18 08:54:33', '2026-04-18 08:54:33'),
(391, 444, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 32, 'Sale: SAL-202604000006', '2026-04-18', '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(392, 143, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 32, 'Sale: SAL-202604000006', '2026-04-18', '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(393, 276, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 32, 'Sale: SAL-202604000006', '2026-04-18', '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(394, 398, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 32, 'Sale: SAL-202604000006', '2026-04-18', '2026-04-18 08:59:56', '2026-04-18 08:59:56'),
(395, 551, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 33, 'Sale: SAL-202604000007', '2026-04-18', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(396, 165, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 33, 'Sale: SAL-202604000007', '2026-04-18', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(397, 352, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 33, 'Sale: SAL-202604000007', '2026-04-18', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(398, 378, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 33, 'Sale: SAL-202604000007', '2026-04-18', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(399, 811, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 33, 'Sale: SAL-202604000007', '2026-04-18', '2026-04-18 09:03:10', '2026-04-18 09:03:10'),
(400, 58, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 34, 'Sale: SAL-202604000008', '2026-04-18', '2026-04-18 09:05:14', '2026-04-18 09:05:14'),
(401, 978, 1, 'purchase', 10, 850.00, NULL, NULL, 'Initial stock: New batch 2014725', '2026-04-18', '2026-04-18 09:28:54', '2026-04-18 09:28:54'),
(402, 979, 1, 'purchase', 10, 825.00, NULL, NULL, 'Initial stock: New batch 2014725', '2026-04-18', '2026-04-18 11:12:07', '2026-04-18 11:12:07'),
(403, 980, 1, 'purchase', 108, 167.00, NULL, NULL, 'Initial stock: New batch 14', '2026-04-18', '2026-04-18 11:21:02', '2026-04-18 11:21:02'),
(404, 980, 1, 'sale', -9, NULL, 'App\\Models\\Sale', 35, 'Sale: SAL-202604000009', '2026-04-18', '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(405, 979, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 35, 'Sale: SAL-202604000009', '2026-04-18', '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(406, 58, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 35, 'Sale: SAL-202604000009', '2026-04-18', '2026-04-18 11:23:37', '2026-04-18 11:23:37'),
(407, 981, 1, 'purchase', 5, 1100.00, NULL, NULL, 'Initial stock: New batch DLDR18', '2026-04-18', '2026-04-18 11:29:41', '2026-04-18 11:29:41'),
(408, 927, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 36, 'Sale: SAL-202604000010', '2026-04-18', '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(409, 460, 1, 'sale', -6, NULL, 'App\\Models\\Sale', 36, 'Sale: SAL-202604000010', '2026-04-18', '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(410, 969, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 36, 'Sale: SAL-202604000010', '2026-04-18', '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(411, 531, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 36, 'Sale: SAL-202604000010', '2026-04-18', '2026-04-18 11:30:40', '2026-04-18 11:30:40'),
(412, 205, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 37, 'Sale: SAL-202604000011', '2026-04-18', '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(413, 800, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 37, 'Sale: SAL-202604000011', '2026-04-18', '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(414, 444, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 37, 'Sale: SAL-202604000011', '2026-04-18', '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(415, 980, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 37, 'Sale: SAL-202604000011', '2026-04-18', '2026-04-18 11:35:48', '2026-04-18 11:35:48'),
(416, 982, 1, 'purchase', 30, 642.00, NULL, NULL, 'Initial stock: New batch L241067', '2026-04-18', '2026-04-18 11:35:58', '2026-04-18 11:35:58'),
(417, 205, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 38, 'Sale: SAL-202604000012', '2026-04-18', '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(418, 618, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 38, 'Sale: SAL-202604000012', '2026-04-18', '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(419, 444, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 38, 'Sale: SAL-202604000012', '2026-04-18', '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(420, 980, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 38, 'Sale: SAL-202604000012', '2026-04-18', '2026-04-18 11:38:26', '2026-04-18 11:38:26'),
(421, 546, 1, 'purchase', 6, 2140.00, NULL, NULL, 'Quick Add Batch: Added 6 units to existing batch PF8002', '2026-04-18', '2026-04-18 11:39:38', '2026-04-18 11:39:38'),
(422, 983, 1, 'purchase', 1, 7800.00, NULL, NULL, 'Initial stock: New batch AGZ893', '2026-04-18', '2026-04-18 11:44:33', '2026-04-18 11:44:33'),
(423, 984, 1, 'purchase', 10, 1500.00, NULL, NULL, 'Initial stock: New batch 1-1-14', '2026-04-18', '2026-04-18 11:47:35', '2026-04-18 11:47:35'),
(424, 985, 1, 'purchase', 2, 8020.00, NULL, NULL, 'Initial stock: New batch SV118', '2026-04-18', '2026-04-18 11:50:16', '2026-04-18 11:50:16'),
(425, 986, 1, 'purchase', 12, 1083.00, NULL, NULL, 'Initial stock: New batch 262A', '2026-04-18', '2026-04-18 11:51:41', '2026-04-18 11:51:41'),
(426, 987, 1, 'purchase', 1, 11000.00, NULL, NULL, 'Initial stock: New batch PRW2431AA', '2026-04-18', '2026-04-18 11:53:44', '2026-04-18 11:53:44'),
(427, 988, 1, 'purchase', 20, 900.00, NULL, NULL, 'Initial stock: New batch 711', '2026-04-18', '2026-04-18 11:57:04', '2026-04-18 11:57:04'),
(428, 989, 1, 'purchase', 1, 21780.00, NULL, NULL, 'Initial stock: New batch 6446689', '2026-04-18', '2026-04-18 11:58:21', '2026-04-18 11:58:21'),
(429, 990, 1, 'purchase', 20, 935.00, NULL, NULL, 'Initial stock: New batch 646', '2026-04-18', '2026-04-18 12:00:12', '2026-04-18 12:00:12'),
(430, 991, 1, 'purchase', 1, 18000.00, NULL, NULL, 'Initial stock: New batch 280D1', '2026-04-18', '2026-04-18 12:01:48', '2026-04-18 12:01:48'),
(431, 992, 1, 'purchase', 50, 150.00, NULL, NULL, 'Initial stock: New batch 6846', '2026-04-18', '2026-04-18 12:03:40', '2026-04-18 12:03:40'),
(432, 993, 1, 'purchase', 1, 20800.00, NULL, NULL, 'Initial stock: New batch PP2542', '2026-04-18', '2026-04-18 12:07:56', '2026-04-18 12:07:56'),
(433, 994, 1, 'purchase', 10, 3350.00, NULL, NULL, 'Initial stock: New batch 051', '2026-04-18', '2026-04-18 12:09:05', '2026-04-18 12:09:05'),
(434, 995, 1, 'purchase', 1, 17655.00, NULL, NULL, 'Initial stock: New batch QTGR25015', '2026-04-18', '2026-04-18 12:23:48', '2026-04-18 12:23:48'),
(435, 996, 1, 'purchase', 10, 2500.00, NULL, NULL, 'Initial stock: New batch 5305', '2026-04-18', '2026-04-18 12:26:31', '2026-04-18 12:26:31'),
(436, 997, 1, 'purchase', 2, 10500.00, NULL, NULL, 'Initial stock: New batch 51062`', '2026-04-18', '2026-04-18 12:26:40', '2026-04-18 12:26:40'),
(437, 998, 1, 'purchase', 12, 2583.00, NULL, NULL, 'Initial stock: New batch 121', '2026-04-18', '2026-04-18 12:30:48', '2026-04-18 12:30:48'),
(438, 999, 1, 'purchase', 1, 12420.00, NULL, NULL, 'Initial stock: New batch F177676', '2026-04-18', '2026-04-18 12:31:21', '2026-04-18 12:31:21'),
(439, 1000, 1, 'purchase', 1, 16900.00, NULL, NULL, 'Initial stock: New batch 51594', '2026-04-18', '2026-04-18 12:34:04', '2026-04-18 12:34:04'),
(440, 1001, 1, 'purchase', 2, 1800.00, NULL, NULL, 'Initial stock: New batch 2025', '2026-04-18', '2026-04-18 12:36:56', '2026-04-18 12:36:56'),
(441, 1002, 1, 'purchase', 12, 1750.00, NULL, NULL, 'Initial stock: New batch T44238A', '2026-04-18', '2026-04-18 12:37:33', '2026-04-18 12:37:33'),
(442, 1003, 1, 'purchase', 1, 13910.00, NULL, NULL, 'Initial stock: New batch 52662', '2026-04-18', '2026-04-18 12:42:03', '2026-04-18 12:42:03'),
(443, 1004, 1, 'purchase', 1, 15785.00, NULL, NULL, 'Initial stock: New batch 51606', '2026-04-18', '2026-04-18 12:46:49', '2026-04-18 12:46:49'),
(444, 19, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 39, 'Sale: SAL-202604000013', '2026-04-18', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(445, 472, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 39, 'Sale: SAL-202604000013', '2026-04-18', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(446, 988, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 39, 'Sale: SAL-202604000013', '2026-04-18', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(447, 426, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 39, 'Sale: SAL-202604000013', '2026-04-18', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(448, 482, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 39, 'Sale: SAL-202604000013', '2026-04-18', '2026-04-18 12:49:18', '2026-04-18 12:49:18'),
(449, 1005, 1, 'purchase', 1, 14445.00, NULL, NULL, 'Initial stock: New batch 51588', '2026-04-18', '2026-04-18 12:50:08', '2026-04-18 12:50:08'),
(450, 1006, 1, 'purchase', 1, 14445.00, NULL, NULL, 'Initial stock: New batch 51601', '2026-04-18', '2026-04-18 12:53:33', '2026-04-18 12:53:33'),
(451, 1007, 1, 'purchase', 1, 18150.00, NULL, NULL, 'Initial stock: New batch 51176', '2026-04-18', '2026-04-18 12:56:14', '2026-04-18 12:56:14'),
(452, 1008, 1, 'purchase', 1, 14780.00, NULL, NULL, 'Initial stock: New batch 51621', '2026-04-18', '2026-04-18 12:58:47', '2026-04-18 12:58:47'),
(453, 1009, 1, 'purchase', 1, 19250.00, NULL, NULL, 'Initial stock: New batch 51538', '2026-04-18', '2026-04-18 13:02:27', '2026-04-18 13:02:27'),
(454, 1009, 1, 'purchase', 1, 19250.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch 51538', '2026-04-18', '2026-04-18 13:04:27', '2026-04-18 13:04:27'),
(455, 1010, 1, 'purchase', 1, 10165.00, NULL, NULL, 'Initial stock: New batch 51648', '2026-04-18', '2026-04-18 13:07:17', '2026-04-18 13:07:17'),
(456, 1011, 1, 'purchase', 1, 500.00, NULL, NULL, 'Initial stock: New batch 714', '2026-04-18', '2026-04-18 13:09:25', '2026-04-18 13:09:25'),
(457, 1012, 1, 'purchase', 6, 3000.00, NULL, NULL, 'Initial stock: New batch 006', '2026-04-18', '2026-04-18 13:11:06', '2026-04-18 13:11:06'),
(458, 1013, 1, 'purchase', 1, 18190.00, NULL, NULL, 'Initial stock: New batch 120224126', '2026-04-18', '2026-04-18 13:11:35', '2026-04-18 13:11:35'),
(459, 1014, 1, 'purchase', 10, 650.00, NULL, NULL, 'Initial stock: New batch L086F', '2026-04-18', '2026-04-18 13:14:40', '2026-04-18 13:14:40'),
(460, 1015, 1, 'purchase', 1, 14300.00, NULL, NULL, 'Initial stock: New batch 930925', '2026-04-18', '2026-04-18 13:21:38', '2026-04-18 13:21:38'),
(461, 1016, 1, 'purchase', 1, 8645.00, NULL, NULL, 'Initial stock: New batch 2501275', '2026-04-18', '2026-04-18 13:25:47', '2026-04-18 13:25:47'),
(462, 1017, 1, 'purchase', 1, 20200.00, NULL, NULL, 'Initial stock: New batch 24264F42', '2026-04-18', '2026-04-18 13:29:32', '2026-04-18 13:29:32'),
(463, 1018, 1, 'purchase', 4, 1900.00, NULL, NULL, 'Initial stock: New batch 003', '2026-04-18', '2026-04-18 13:30:07', '2026-04-18 13:30:07'),
(464, 825, 1, 'purchase', 2, 1800.00, NULL, NULL, 'Quick Add Batch: Added 2 units to existing batch SKO0145', '2026-04-18', '2026-04-18 13:31:15', '2026-04-18 13:31:15'),
(465, 1019, 1, 'purchase', 6, 300.00, NULL, NULL, 'Initial stock: New batch XT5G026', '2026-04-18', '2026-04-18 13:36:23', '2026-04-18 13:36:23'),
(466, 1020, 1, 'purchase', 2, 3600.00, NULL, NULL, 'Initial stock: New batch 51547LD', '2026-04-18', '2026-04-18 13:39:26', '2026-04-18 13:39:26'),
(467, 1021, 1, 'purchase', 3, 1180.00, NULL, NULL, 'Initial stock: New batch ACE26001', '2026-04-18', '2026-04-18 13:40:52', '2026-04-18 13:40:52'),
(468, 1022, 1, 'purchase', 2, 3600.00, NULL, NULL, 'Initial stock: New batch 51507LD', '2026-04-18', '2026-04-18 13:43:49', '2026-04-18 13:43:49'),
(469, 1023, 1, 'purchase', 5, 1925.00, NULL, NULL, 'Initial stock: New batch 324-1318', '2026-04-18', '2026-04-18 13:44:19', '2026-04-18 13:44:19'),
(470, 1024, 1, 'purchase', 3, 1100.00, NULL, NULL, 'Initial stock: New batch M25F012', '2026-04-18', '2026-04-18 13:50:27', '2026-04-18 13:50:27'),
(471, 1025, 1, 'purchase', 2, 3600.00, NULL, NULL, 'Initial stock: New batch B092', '2026-04-18', '2026-04-18 13:51:22', '2026-04-18 13:51:22'),
(472, 1026, 1, 'purchase', 3, 1135.00, NULL, NULL, 'Initial stock: New batch S2421045', '2026-04-18', '2026-04-18 13:54:18', '2026-04-18 13:54:18'),
(473, 1027, 1, 'purchase', 1, 1600.00, NULL, NULL, 'Initial stock: New batch A311009', '2026-04-18', '2026-04-18 13:57:48', '2026-04-18 13:57:48'),
(474, 1028, 1, 'purchase', 2, 1250.00, NULL, NULL, 'Initial stock: New batch 20230328', '2026-04-18', '2026-04-18 14:01:44', '2026-04-18 14:01:44'),
(475, 1029, 1, 'purchase', 2, 635.00, NULL, NULL, 'Initial stock: New batch 24410', '2026-04-18', '2026-04-18 14:04:41', '2026-04-18 14:04:41'),
(476, 642, 1, 'purchase', 10, 400.00, NULL, NULL, 'Quick Add Batch: Added 10 units to existing batch AR241108', '2026-04-18', '2026-04-18 14:06:51', '2026-04-18 14:06:51'),
(477, 1030, 1, 'purchase', 5, 1100.00, NULL, NULL, 'Initial stock: New batch S25C031', '2026-04-18', '2026-04-18 14:13:03', '2026-04-18 14:13:03'),
(478, 1031, 1, 'purchase', 1, 3500.00, NULL, NULL, 'Initial stock: New batch 912B', '2026-04-18', '2026-04-18 14:14:24', '2026-04-18 14:14:24'),
(479, 1032, 1, 'purchase', 1, 10500.00, NULL, NULL, 'Initial stock: New batch 0HT25100', '2026-04-18', '2026-04-18 14:16:32', '2026-04-18 14:16:32'),
(480, 1033, 1, 'purchase', 1, 3500.00, NULL, NULL, 'Initial stock: New batch 812C', '2026-04-18', '2026-04-18 14:19:24', '2026-04-18 14:19:24'),
(481, 1034, 1, 'purchase', 3, 1245.00, NULL, NULL, 'Initial stock: New batch ANNH0026', '2026-04-18', '2026-04-18 14:20:11', '2026-04-18 14:20:11'),
(482, 1035, 1, 'purchase', 1, 3500.00, NULL, NULL, 'Initial stock: New batch 212B', '2026-04-18', '2026-04-18 14:22:11', '2026-04-18 14:22:11'),
(483, 1036, 1, 'purchase', 2, 2300.00, NULL, NULL, 'Initial stock: New batch L4PP', '2026-04-18', '2026-04-18 14:25:23', '2026-04-18 14:25:23'),
(484, 1037, 1, 'purchase', 5, 1070.00, NULL, NULL, 'Initial stock: New batch AE21722', '2026-04-18', '2026-04-18 14:26:33', '2026-04-18 14:26:33'),
(485, 1038, 1, 'purchase', 3, 860.00, NULL, NULL, 'Initial stock: New batch AE06153', '2026-04-18', '2026-04-18 14:30:29', '2026-04-18 14:30:29'),
(486, 1039, 1, 'purchase', 3, 2400.00, NULL, NULL, 'Initial stock: New batch 2026', '2026-04-18', '2026-04-18 14:33:15', '2026-04-18 14:33:15'),
(487, 1040, 1, 'purchase', 10, 180.00, NULL, NULL, 'Initial stock: New batch H23042', '2026-04-18', '2026-04-18 14:36:40', '2026-04-18 14:36:40'),
(488, 1041, 1, 'purchase', 2, 1800.00, NULL, NULL, 'Initial stock: New batch 225', '2026-04-18', '2026-04-18 14:38:42', '2026-04-18 14:38:42'),
(489, 1042, 1, 'purchase', 10, 145.00, NULL, NULL, 'Initial stock: New batch 240882', '2026-04-18', '2026-04-18 14:41:29', '2026-04-18 14:41:29'),
(490, 1043, 1, 'purchase', 2, 610.00, NULL, NULL, 'Initial stock: New batch 25307', '2026-04-18', '2026-04-18 14:44:09', '2026-04-18 14:44:09'),
(491, 1044, 1, 'purchase', 4, 1800.00, NULL, NULL, 'Initial stock: New batch 5023', '2026-04-18', '2026-04-18 14:46:44', '2026-04-18 14:46:44'),
(492, 1045, 1, 'purchase', 2, 295.00, NULL, NULL, 'Initial stock: New batch 002', '2026-04-18', '2026-04-18 14:46:59', '2026-04-18 14:46:59'),
(493, 224, 1, 'purchase', 3, 480.00, NULL, NULL, 'Quick Add Batch: Added 3 units to existing batch 20250326', '2026-04-18', '2026-04-18 14:49:55', '2026-04-18 14:49:55'),
(494, 1046, 1, 'purchase', 6, 800.00, NULL, NULL, 'Initial stock: New batch 6013K', '2026-04-18', '2026-04-18 14:53:36', '2026-04-18 14:53:36'),
(495, 1047, 1, 'purchase', 4, 1800.00, NULL, NULL, 'Initial stock: New batch ABH7500', '2026-04-18', '2026-04-18 14:56:59', '2026-04-18 14:56:59'),
(496, 1048, 1, 'purchase', 5, 3000.00, NULL, NULL, 'Initial stock: New batch EMF25001', '2026-04-18', '2026-04-18 14:59:25', '2026-04-18 14:59:25'),
(497, 1049, 1, 'purchase', 6, 550.00, NULL, NULL, 'Initial stock: New batch ABH8082', '2026-04-18', '2026-04-18 15:01:07', '2026-04-18 15:01:07'),
(498, 1050, 1, 'purchase', 6, 200.00, NULL, NULL, 'Initial stock: New batch EEN504', '2026-04-18', '2026-04-18 15:02:23', '2026-04-18 15:02:23'),
(499, 1051, 1, 'purchase', 5, 700.00, NULL, NULL, 'Initial stock: New batch L566E', '2026-04-18', '2026-04-18 15:05:47', '2026-04-18 15:05:47'),
(500, 1052, 1, 'purchase', 3, 3000.00, NULL, NULL, 'Initial stock: New batch 333', '2026-04-18', '2026-04-18 15:05:59', '2026-04-18 15:05:59'),
(501, 1053, 1, 'purchase', 2, 15500.00, NULL, NULL, 'Initial stock: New batch B9467N', '2026-04-18', '2026-04-18 15:09:13', '2026-04-18 15:09:13'),
(502, 1054, 1, 'purchase', 10, 980.00, NULL, NULL, 'Initial stock: New batch 53b25044A', '2026-04-18', '2026-04-18 15:11:04', '2026-04-18 15:11:04'),
(503, 1055, 1, 'purchase', 4, 1125.00, NULL, NULL, 'Initial stock: New batch 50972AV07', '2026-04-18', '2026-04-18 15:13:45', '2026-04-18 15:13:45'),
(504, 1056, 1, 'purchase', 3, 1500.00, NULL, NULL, 'Initial stock: New batch AE15263', '2026-04-18', '2026-04-18 15:14:41', '2026-04-18 15:14:41'),
(505, 1057, 1, 'purchase', 3, 4166.67, NULL, NULL, 'Initial stock: New batch 25D05C1', '2026-04-18', '2026-04-18 15:18:56', '2026-04-18 15:18:56'),
(506, 442, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 40, 'Sale: SAL-202604000014', '2026-04-18', '2026-04-18 15:21:19', '2026-04-18 15:21:19'),
(507, 1058, 1, 'purchase', 3, 1050.00, NULL, NULL, 'Initial stock: New batch AE22581', '2026-04-18', '2026-04-18 15:21:43', '2026-04-18 15:21:43'),
(508, 621, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 41, 'Sale: SAL-202604000015', '2026-04-18', '2026-04-18 15:24:21', '2026-04-18 15:24:21'),
(509, 1059, 1, 'purchase', 2, 2980.00, NULL, NULL, 'Initial stock: New batch 40191002', '2026-04-18', '2026-04-18 15:24:29', '2026-04-18 15:24:29'),
(510, 818, 1, 'purchase', 2, 1750.00, NULL, NULL, 'Quick Add Batch: Added 2 units to existing batch W12508', '2026-04-18', '2026-04-18 15:25:52', '2026-04-18 15:25:52'),
(511, 1060, 1, 'purchase', 2, 1250.00, NULL, NULL, 'Initial stock: New batch W25038', '2026-04-18', '2026-04-18 15:27:40', '2026-04-18 15:27:40'),
(512, 122, 1, 'purchase', 10, 95.00, NULL, NULL, 'Quick Add Batch: Added 10 units to existing batch 251019', '2026-04-18', '2026-04-18 15:29:58', '2026-04-18 15:29:58'),
(513, 1061, 1, 'purchase', 12, 625.00, NULL, NULL, 'Initial stock: New batch 04190225', '2026-04-18', '2026-04-18 15:31:51', '2026-04-18 15:31:51'),
(514, 124, 1, 'purchase', 3, 720.00, NULL, NULL, 'Quick Add Batch: Added 3 units to existing batch 25363', '2026-04-18', '2026-04-18 15:34:07', '2026-04-18 15:34:07'),
(515, 1062, 1, 'purchase', 2, 3210.00, NULL, NULL, 'Initial stock: New batch 188L0128', '2026-04-18', '2026-04-18 15:39:31', '2026-04-18 15:39:31'),
(516, 1063, 1, 'purchase', 2, 4500.00, NULL, NULL, 'Initial stock: New batch 24252', '2026-04-18', '2026-04-18 15:42:54', '2026-04-18 15:42:54'),
(517, 1064, 1, 'purchase', 10, 270.00, NULL, NULL, 'Initial stock: New batch 251116', '2026-04-18', '2026-04-18 15:43:47', '2026-04-18 15:43:47'),
(518, 544, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 42, 'Sale: SAL-202604000016', '2026-04-18', '2026-04-18 15:45:41', '2026-04-18 15:45:41'),
(519, 246, 1, 'sale', -4, NULL, 'App\\Models\\Sale', 42, 'Sale: SAL-202604000016', '2026-04-18', '2026-04-18 15:45:41', '2026-04-18 15:45:41'),
(520, 1065, 1, 'purchase', 6, 225.00, NULL, NULL, 'Initial stock: New batch ENS503', '2026-04-18', '2026-04-18 15:50:37', '2026-04-18 15:50:37'),
(521, 1066, 1, 'purchase', 2, 2000.00, NULL, NULL, 'Initial stock: New batch 1568L2401', '2026-04-18', '2026-04-18 15:54:39', '2026-04-18 15:54:39'),
(522, 1067, 1, 'purchase', 3, 550.00, NULL, NULL, 'Initial stock: New batch S0518SE', '2026-04-18', '2026-04-18 15:58:27', '2026-04-18 15:58:27'),
(523, 1068, 1, 'purchase', 1, 775.00, NULL, NULL, 'Initial stock: New batch I51H0327', '2026-04-18', '2026-04-18 16:02:29', '2026-04-18 16:02:29'),
(524, 713, 1, 'purchase', 1, 1685.00, NULL, NULL, 'Quick Add Batch: Added 1 units to existing batch 18G0129', '2026-04-18', '2026-04-18 16:04:41', '2026-04-18 16:04:41'),
(525, 1069, 1, 'purchase', 3, 1233.33, NULL, NULL, 'Initial stock: New batch 26001', '2026-04-18', '2026-04-18 16:09:43', '2026-04-18 16:09:43'),
(526, 1070, 1, 'purchase', 5, 575.00, NULL, NULL, 'Initial stock: New batch 25043', '2026-04-18', '2026-04-18 16:13:02', '2026-04-18 16:13:02'),
(527, 1071, 1, 'purchase', 2, 425.00, NULL, NULL, 'Initial stock: New batch 2170225', '2026-04-18', '2026-04-18 16:15:55', '2026-04-18 16:15:55'),
(528, 1072, 1, 'purchase', 1, 6400.00, NULL, NULL, 'Initial stock: New batch GT2745', '2026-04-18', '2026-04-18 16:19:25', '2026-04-18 16:19:25'),
(529, 1073, 1, 'purchase', 100, 47.00, NULL, NULL, 'Initial stock: New batch 20241230', '2026-04-18', '2026-04-18 16:25:30', '2026-04-18 16:25:30'),
(530, 1074, 1, 'purchase', 100, 43.00, NULL, NULL, 'Initial stock: New batch 250210', '2026-04-18', '2026-04-18 16:29:05', '2026-04-18 16:29:05'),
(531, 1075, 1, 'purchase', 1, 4500.00, NULL, NULL, 'Initial stock: New batch 24203', '2026-04-18', '2026-04-18 16:29:29', '2026-04-18 16:29:29'),
(532, 1076, 1, 'purchase', 10, 980.00, NULL, NULL, 'Initial stock: New batch 25J1382', '2026-04-18', '2026-04-18 16:33:48', '2026-04-18 16:33:48'),
(533, 1077, 1, 'purchase', 3, 495.00, NULL, NULL, 'Initial stock: New batch T32601', '2026-04-18', '2026-04-18 16:37:38', '2026-04-18 16:37:38'),
(534, 1078, 1, 'purchase', 5, 740.00, NULL, NULL, 'Initial stock: New batch 250433', '2026-04-18', '2026-04-18 16:40:46', '2026-04-18 16:40:46'),
(535, 1079, 1, 'purchase', 10, 1000.00, NULL, NULL, 'Initial stock: New batch 659241223', '2026-04-18', '2026-04-18 16:45:17', '2026-04-18 16:45:17'),
(536, 1080, 1, 'purchase', 2, 1750.00, NULL, NULL, 'Initial stock: New batch 794250402', '2026-04-18', '2026-04-18 16:48:14', '2026-04-18 16:48:14'),
(537, 1081, 1, 'purchase', 3, 1518.33, NULL, NULL, 'Initial stock: New batch S2520410', '2026-04-18', '2026-04-18 16:52:26', '2026-04-18 16:52:26'),
(538, 1082, 1, 'purchase', 2, 660.00, NULL, NULL, 'Initial stock: New batch CM24246', '2026-04-18', '2026-04-18 16:54:54', '2026-04-18 16:54:54'),
(539, 297, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 43, 'Sale: SAL-202604000017', '2026-04-18', '2026-04-18 16:54:59', '2026-04-18 16:54:59'),
(540, 158, 1, 'purchase', 2, 3700.00, NULL, NULL, 'Quick Add Batch: Added 2 units to existing batch 25cq025', '2026-04-18', '2026-04-18 16:56:33', '2026-04-18 16:56:33'),
(541, 59, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 44, 'Sale: SAL-202604000018', '2026-04-18', '2026-04-18 16:59:12', '2026-04-18 16:59:12'),
(542, 1083, 1, 'purchase', 10, 340.00, NULL, NULL, 'Initial stock: New batch S14F', '2026-04-18', '2026-04-18 17:00:00', '2026-04-18 17:00:00'),
(543, 127, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 45, 'Sale: SAL-202604000019', '2026-04-18', '2026-04-18 17:02:02', '2026-04-18 17:02:02'),
(544, 558, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 46, 'Sale: SAL-202604000020', '2026-04-18', '2026-04-18 17:15:35', '2026-04-18 17:15:35'),
(545, 510, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 46, 'Sale: SAL-202604000020', '2026-04-18', '2026-04-18 17:15:35', '2026-04-18 17:15:35'),
(546, 759, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 47, 'Sale: SAL-202604000021', '2026-04-18', '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(547, 581, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 47, 'Sale: SAL-202604000021', '2026-04-18', '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(548, 506, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 47, 'Sale: SAL-202604000021', '2026-04-18', '2026-04-18 17:38:49', '2026-04-18 17:38:49'),
(549, 206, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 48, 'Sale: SAL-202604000022', '2026-04-18', '2026-04-18 18:55:22', '2026-04-18 18:55:22'),
(550, 511, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 48, 'Sale: SAL-202604000022', '2026-04-18', '2026-04-18 18:55:22', '2026-04-18 18:55:22'),
(551, 460, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 49, 'Sale: SAL-202604000023', '2026-04-20', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(552, 980, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 49, 'Sale: SAL-202604000023', '2026-04-20', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(553, 188, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 49, 'Sale: SAL-202604000023', '2026-04-20', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(554, 509, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 49, 'Sale: SAL-202604000023', '2026-04-20', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(555, 511, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 49, 'Sale: SAL-202604000023', '2026-04-20', '2026-04-20 08:17:52', '2026-04-20 08:17:52'),
(556, 583, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(557, 581, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(558, 133, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(559, 560, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(560, 352, 1, 'sale', -3, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(561, 115, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(562, 643, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(563, 831, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 50, 'Sale: SAL-202604000024', '2026-04-20', '2026-04-20 08:34:59', '2026-04-20 08:34:59'),
(564, 481, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 51, 'Sale: SAL-202604000025', '2026-04-20', '2026-04-20 09:33:46', '2026-04-20 09:33:46'),
(565, 979, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 52, 'Sale: SAL-202604000026', '2026-04-20', '2026-04-20 09:42:47', '2026-04-20 09:42:47'),
(566, 701, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 53, 'Sale: SAL-202604000027', '2026-04-20', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(567, 504, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 53, 'Sale: SAL-202604000027', '2026-04-20', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(568, 445, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 53, 'Sale: SAL-202604000027', '2026-04-20', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(569, 446, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 53, 'Sale: SAL-202604000027', '2026-04-20', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(570, 980, 1, 'sale', -2, NULL, 'App\\Models\\Sale', 53, 'Sale: SAL-202604000027', '2026-04-20', '2026-04-20 12:36:36', '2026-04-20 12:36:36'),
(571, 814, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 54, 'Sale: SAL-202604000028', '2026-04-20', '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(572, 115, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 54, 'Sale: SAL-202604000028', '2026-04-20', '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(573, 564, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 54, 'Sale: SAL-202604000028', '2026-04-20', '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(574, 502, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 54, 'Sale: SAL-202604000028', '2026-04-20', '2026-04-20 12:37:59', '2026-04-20 12:37:59'),
(575, 708, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 55, 'Sale: SAL-202604000029', '2026-04-20', '2026-04-20 13:03:54', '2026-04-20 13:03:54'),
(576, 563, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 55, 'Sale: SAL-202604000029', '2026-04-20', '2026-04-20 13:03:54', '2026-04-20 13:03:54'),
(577, 482, 1, 'sale', -1, NULL, 'App\\Models\\Sale', 55, 'Sale: SAL-202604000029', '2026-04-20', '2026-04-20 13:03:54', '2026-04-20 13:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfers`
--

CREATE TABLE `stock_transfers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `transfer_number` varchar(50) NOT NULL COMMENT 'Auto-generated transfer number (TRF-YYYY-MM-NNNN)',
  `from_branch_id` bigint(20) UNSIGNED NOT NULL,
  `to_branch_id` bigint(20) UNSIGNED NOT NULL,
  `requested_by` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `transfer_date` date NOT NULL COMMENT 'Transfer date',
  `status` enum('pending','approved','in_transit','received','cancelled') NOT NULL DEFAULT 'pending' COMMENT 'Transfer status',
  `notes` text DEFAULT NULL COMMENT 'Transfer notes',
  `approved_at` timestamp NULL DEFAULT NULL COMMENT 'Approval timestamp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfer_items`
--

CREATE TABLE `stock_transfer_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `stock_transfer_id` bigint(20) UNSIGNED NOT NULL,
  `stock_item_id` bigint(20) UNSIGNED NOT NULL,
  `drug_id` bigint(20) UNSIGNED NOT NULL,
  `batch_number` varchar(100) NOT NULL COMMENT 'Batch number (denormalized)',
  `quantity` int(11) NOT NULL COMMENT 'Quantity to transfer',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Subcategory name (e.g., Antibiotics, Pain Relief)',
  `slug` varchar(255) NOT NULL COMMENT 'URL-friendly slug',
  `description` text DEFAULT NULL COMMENT 'Subcategory description',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Active status',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Display order',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`id`, `category_id`, `name`, `slug`, `description`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 2, 'MouthWash', 'mouthwash', NULL, 1, 1, '2026-01-10 18:54:13', '2026-04-07 11:40:25'),
(4, 2, 'Antifungal', 'antifungal', NULL, 1, 2, '2026-04-03 10:23:26', '2026-04-03 10:23:26'),
(5, 2, 'Medical & First Aid Device/Instrument /Injectables', 'medical-first-aid-deviceinstrument-injectables', NULL, 1, 3, '2026-04-03 10:44:35', '2026-04-10 13:52:26'),
(6, 2, 'Antiallergy, Antihistamine, Steroid, Antiasthmatic', 'antiallergy-antihistamine-steroid-antiasthmatic', NULL, 1, 4, '2026-04-03 10:59:27', '2026-04-06 13:46:01'),
(7, 2, 'Antacid, Antiulcer, Laxative, Antidiarrhea', 'antacid-antiulcer-laxative-antidiarrhea', NULL, 1, 5, '2026-04-03 11:06:45', '2026-04-06 13:46:22'),
(8, 2, 'Antibiotic', 'antibiotic', NULL, 1, 6, '2026-04-03 11:10:58', '2026-04-03 11:10:58'),
(9, 2, 'Blood Builder, Appetite booster, Probiotics', 'blood-builder-appetite-booster-probiotics', NULL, 1, 7, '2026-04-03 11:40:30', '2026-04-10 14:57:43'),
(10, 2, 'Fever, Anti Inflammatory, Anesthetics, Pain Killer', 'fever-anti-inflammatory-anesthetics-pain-killer', NULL, 1, 8, '2026-04-03 11:51:13', '2026-04-03 11:51:34'),
(11, 2, 'Cough Syrup & Tablet / Cold, Flu, Catarrh / Lonzenges', 'cough-syrup-tablet-cold-flu-catarrh-lonzenges', NULL, 1, 9, '2026-04-03 11:53:39', '2026-04-06 16:47:19'),
(12, 2, 'Food & Herbal Supplements, Vitamins, Minerals', 'food-herbal-supplements-vitamins-minerals', NULL, 1, 10, '2026-04-03 11:56:52', '2026-04-03 11:56:52'),
(13, 2, 'Inhealer, Nasal Spray & Drops, Eye Drops/Ointment, Ear Drops', 'inhealer-nasal-spray-drops-eye-dropsointment-ear-drops', NULL, 1, 11, '2026-04-03 13:14:16', '2026-04-12 08:52:33'),
(15, 2, 'Worm Expellant / Anti-Parasitic', 'worm-expellant-anti-parasitic', NULL, 1, 12, '2026-04-03 13:37:39', '2026-04-03 15:30:23'),
(16, 2, 'Antiseptics, Sanitizers & Disinfectant', 'antiseptics-sanitizers-disinfectant', NULL, 1, 13, '2026-04-03 13:53:44', '2026-04-03 13:53:44'),
(17, 2, 'Aphrodisiacs, Condoms, Lubricants', 'aphrodisiacs-condoms-lubricants', NULL, 1, 14, '2026-04-03 13:59:32', '2026-04-12 12:49:10'),
(18, 2, 'Dentals Solutions & Floss', 'dentals-solutions-floss', NULL, 1, 15, '2026-04-03 14:30:42', '2026-04-03 14:30:42'),
(20, 2, 'Anti-Malaria', 'anti-malaria', NULL, 1, 16, '2026-04-04 14:18:45', '2026-04-04 14:18:45'),
(21, 2, 'Dysmenorrhea / Fertility /Antineoplastic', 'dysmenorrhea-fertility-antineoplastic', NULL, 1, 17, '2026-04-06 12:31:40', '2026-04-06 14:32:45'),
(22, 2, 'Anti-Diabetics', 'anti-diabetics', NULL, 1, 18, '2026-04-06 12:43:36', '2026-04-06 12:43:36'),
(23, 2, 'Cardiovascular / Anti-Cholesterol', 'cardiovascular-anti-cholesterol', NULL, 1, 19, '2026-04-06 13:01:38', '2026-04-06 13:20:32'),
(25, 2, 'Antidepressant / Sleeping Aid / Anticonvulsant / Antipsychotic', 'antidepressant-sleeping-aid-anticonvulsant-antipsychotic', NULL, 1, 21, '2026-04-06 14:06:14', '2026-04-07 12:03:21'),
(26, 2, 'Anti-Neuropathy / Gout', 'anti-neuropathy-gout', NULL, 1, 22, '2026-04-06 15:10:56', '2026-04-10 13:45:26'),
(27, 2, 'Muscle Relaxant', 'muscle-relaxant', NULL, 1, 23, '2026-04-07 12:48:41', '2026-04-07 12:48:41'),
(28, 2, 'Anti-diuretic', 'anti-diuretic', NULL, 1, 24, '2026-04-10 13:12:21', '2026-04-10 13:12:21'),
(29, 2, 'Anti-Repellant Cream, Gel & Spray', 'anti-repellant-cream-gel-spray', NULL, 1, 25, '2026-04-10 13:39:38', '2026-04-10 13:39:38'),
(30, 2, 'Anti Prostrate, Anti Cancer, Bile Acid', 'anti-prostrate-anti-cancer-bile-acid', NULL, 1, 26, '2026-04-10 15:55:52', '2026-04-12 15:11:13'),
(31, 2, 'Skin Care', 'skin-care', NULL, 1, 27, '2026-04-10 16:07:53', '2026-04-10 16:07:53'),
(32, 2, 'Powder E.g Dusting Powder etc', 'powder-eg-dusting-powder-etc', NULL, 1, 28, '2026-04-10 16:26:25', '2026-04-10 16:26:25'),
(33, 2, 'Hemorrhoids (Piles)', 'hemorrhoids-piles', NULL, 1, 29, '2026-04-11 13:00:19', '2026-04-11 13:00:19'),
(34, 2, 'GIT, Dehydration& Electrolyte Etc', 'git-dehydration-electrolyte-etc', NULL, 1, 30, '2026-04-11 15:05:55', '2026-04-11 15:05:55'),
(35, 2, 'CNS & ,Anti-Depressant', 'cns-anti-depressant', NULL, 1, 31, '2026-04-11 16:49:18', '2026-04-11 16:49:18'),
(36, 2, 'Opioid', 'opioid', 'Prescription Only', 1, 32, '2026-04-12 12:43:24', '2026-04-12 12:43:24'),
(37, 2, 'AntiViral', 'antiviral', NULL, 1, 33, '2026-04-12 15:16:41', '2026-04-12 15:16:41'),
(38, 2, 'Migraines', 'migraines', NULL, 1, 34, '2026-04-12 15:34:43', '2026-04-12 15:34:43'),
(39, 2, 'Contraceptives Pills', 'contraceptives-pills', NULL, 1, 35, '2026-04-18 11:27:10', '2026-04-18 11:27:10');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Supplier/vendor name',
  `contact_person` varchar(255) DEFAULT NULL COMMENT 'Primary contact person',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Contact phone',
  `email` varchar(100) DEFAULT NULL COMMENT 'Contact email',
  `address` text DEFAULT NULL COMMENT 'Physical address',
  `payment_terms` varchar(50) NOT NULL DEFAULT 'Cash' COMMENT 'Payment terms (Cash, Net 30, Net 60)',
  `delivery_days` int(11) NOT NULL DEFAULT 7 COMMENT 'Expected delivery time in days',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Active status flag',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_person`, `phone`, `email`, `address`, `payment_terms`, `delivery_days`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Emzor Pharmaceutical Industries Ltd', 'Mr. Chukwuma Okafor', '+234 1 234 5678', 'sales@emzor.com.ng', '3-4 Emzor Crescent, Apapa, Lagos State', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(2, 'Fidson Healthcare Plc', 'Mrs. Amina Bello', '+234 1 345 6789', 'orders@fidson.com', '268 Ikorodu Road, Obanikoro, Lagos State', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(3, 'GlaxoSmithKline Nigeria', 'Dr. Oluwaseun Adeyemi', '+234 1 456 7890', 'nigeria@gsk.com', '1 Industrial Avenue, Ilupeju, Lagos State', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(4, 'Juhel Nigeria Limited', 'Mr. Ibrahim Yusuf', '+234 1 567 8901', 'info@juhel.com.ng', 'Plot 44, Block 2, Isolo Industrial Estate, Lagos', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(5, 'Pfizer Products Limited', 'Mrs. Ngozi Eze', '+234 1 678 9012', 'nigeria.orders@pfizer.com', '4 Afribank Street, Victoria Island, Lagos', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(6, 'Sanofi-Aventis Nigeria Limited', 'Mr. Tunde Bakare', '+234 1 789 0123', 'orders@sanofi.com.ng', 'Km 21, Lagos-Badagry Expressway, Ojo, Lagos', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(7, 'May & Baker Nigeria Plc', 'Dr. Fatima Mohammed', '+234 1 890 1234', 'sales@maybaker.com.ng', '3/5 Sapara Street, Industrial Estate, Ikeja, Lagos', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL),
(8, 'Neimeth International Pharmaceuticals', 'Mr. Chidi Okonkwo', '+234 1 901 2345', 'info@neimeth.com', '1 Henry Carr Street, Ikeja, Lagos State', 'Cash', 7, 1, '2026-01-10 17:52:45', '2026-01-10 17:52:45', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `system_configs`
--

CREATE TABLE `system_configs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(100) NOT NULL COMMENT 'Configuration key',
  `value` text DEFAULT NULL COMMENT 'Configuration value',
  `type` varchar(20) NOT NULL DEFAULT 'string' COMMENT 'Value type: string, number, boolean, json',
  `group` varchar(50) NOT NULL DEFAULT 'general' COMMENT 'Configuration group',
  `description` text DEFAULT NULL COMMENT 'Description of the setting',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_configs`
--

INSERT INTO `system_configs` (`id`, `key`, `value`, `type`, `group`, `description`, `created_at`, `updated_at`) VALUES
(1, 'receipt_business_name', 'RYAN\'S WELLNESS PHARMACY', 'string', 'receipt', 'Business name displayed on receipts (uses branch name if empty)', '2026-01-10 17:50:43', '2026-01-23 09:47:32'),
(2, 'receipt_header_title', 'SALES RECEIPT', 'string', 'receipt', 'Main title displayed on receipts', '2026-01-10 17:50:43', '2026-01-10 17:50:43'),
(3, 'receipt_footer_message', 'Thank you for your business - I', 'string', 'receipt', 'Footer message on receipts', '2026-01-10 17:50:43', '2026-01-23 09:47:32'),
(4, 'vat_rate', '7.5', 'number', 'tax', 'VAT percentage rate (e.g., 7.5 for 7.5%)', '2026-01-10 17:50:43', '2026-01-10 22:57:48'),
(5, 'vat_display_text', 'VAT', 'string', 'tax', 'Label for VAT on receipts and invoices', '2026-01-10 17:50:43', '2026-01-10 17:50:43');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Full name',
  `email` varchar(255) NOT NULL COMMENT 'Email address for login',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `authorization_code` varchar(6) DEFAULT NULL COMMENT '6-digit PIN for quick authorization of sensitive operations',
  `can_authorize` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether this user can authorize sensitive operations',
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Active status flag',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `authorization_code`, `can_authorize`, `role_id`, `branch_id`, `is_active`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Admin User', 'admin@dasipharma.ng', NULL, '$2y$12$P9tIAOkI8TY68dGoBAiPbO8N0CBWI7i6Qfuz.JqkAujbH2a2n.5pS', NULL, 1, 1, 7, 1, NULL, '2026-01-10 17:52:45', '2026-04-21 09:14:58', NULL),
(2, 'Dr. Adebayo Okonkwo', 'adebayo@dasipharma.ng', NULL, '$2y$12$G9zPTdXd045t.yzA1BtG8uNy6i4S.RL1YZE3tlbSQynWNsPd8X01e', NULL, 0, 2, 7, 1, NULL, '2026-01-10 17:52:45', '2026-04-17 11:48:40', '2026-04-17 11:48:40'),
(3, 'Pharm. Chioma Nwosu', 'chioma@dasipharma.ng', NULL, '$2y$12$IWDFDteISyaah90Y1v1rE.s4Vp4vEuqbNUIpS6IAEvkSHVhKIxapu', NULL, 0, 2, 2, 0, NULL, '2026-01-10 17:52:45', '2026-01-10 22:55:25', '2026-01-10 22:55:25'),
(4, 'Ibrahim Musa', 'ibrahim@dasipharma.ng', NULL, '$2y$12$s2B2ckBncPJka/0ofFtQterBxYfDqcGoBePK/OTA02O5uBwew4aiS', NULL, 0, 3, 1, 1, NULL, '2026-01-10 17:52:45', '2026-01-10 22:56:09', '2026-01-10 22:56:09'),
(5, 'Ngozi Eze', 'ngozi@dasipharma.ng', NULL, '$2y$12$yGhncSSCh.sGuufAKh9anuu6XJU.Wk/P0p5bdwOEM3rOpE1WMujlu', NULL, 0, 3, 3, 0, NULL, '2026-01-10 17:52:45', '2026-01-10 22:56:03', '2026-01-10 22:56:03'),
(6, 'Tunde Adeyemi', 'tunde@dasipharma.ng', NULL, '$2y$12$LefImoovYdZkw0MnfyclR.r4YDiiyG9gvZUR9Vljhp6y1RIsvSy7q', NULL, 0, 4, 1, 1, NULL, '2026-01-10 17:52:45', '2026-01-10 22:55:19', '2026-01-10 22:55:19'),
(7, 'Blessing Okoro', 'blessing@dasipharma.ng', NULL, '$2y$12$suXxn/1s5qFq9rZmVdXBp.c8XKSV8uJ5VzbhzwIokgQRzL3z1L/x.', NULL, 0, 4, 2, 0, NULL, '2026-01-10 17:52:45', '2026-01-10 22:56:13', '2026-01-10 22:56:13'),
(8, 'Daniel Ekpo', 'sales@dasipharma.com', NULL, '$2y$12$nZLXNI5cJ.IJ.PBO2kSMQ.mW/KXcnMIPaizsOzF9CDRpuyJgzOlm2', NULL, 0, 4, 7, 1, 'JiDTxB33SIo6Os2PboHjNnwdKGtN6u9pL5oizkBHSea6VQybWX6fPoBWJf5h', '2026-01-13 16:58:28', '2026-04-17 11:48:43', '2026-04-17 11:48:43'),
(9, 'John', 'john@me.com', NULL, '$2y$12$3IPcMd0G67jXF2j.1yRCeeUYlMWrN5NNOiLJlHigGWZDensARWEcy', NULL, 0, 5, 7, 1, NULL, '2026-01-23 09:41:50', '2026-04-17 11:48:38', '2026-04-17 11:48:38'),
(10, 'victoria Damisa', 'vicky@gmail.com', NULL, '$2y$12$cSw35EDTMQ44HcnSvHq6COUmKL6.InQ9H1HSHRP55xj5lipLVhK2i', NULL, 0, 2, 7, 1, NULL, '2026-01-23 09:58:38', '2026-04-17 11:48:31', '2026-04-17 11:48:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `branches_code_unique` (`code`),
  ADD KEY `branches_code_index` (`code`),
  ADD KEY `branches_is_active_deleted_at_index` (`is_active`,`deleted_at`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_name_unique` (`name`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indexes for table `drugs`
--
ALTER TABLE `drugs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_drug_variant` (`brand_name`,`strength`,`dosage_form`),
  ADD UNIQUE KEY `drugs_barcode_unique_active` (`barcode`,`barcode_active`),
  ADD KEY `drugs_generic_name_index` (`generic_name`),
  ADD KEY `drugs_is_prescription_only_controlled_substance_class_index` (`is_prescription_only`,`controlled_substance_class`),
  ADD KEY `drugs_category_id_foreign` (`category_id`),
  ADD KEY `drugs_subcategory_id_foreign` (`subcategory_id`);
ALTER TABLE `drugs` ADD FULLTEXT KEY `drug_search_fulltext` (`brand_name`,`generic_name`);

--
-- Indexes for table `goods_received_items`
--
ALTER TABLE `goods_received_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `goods_received_items_grn_id_index` (`grn_id`),
  ADD KEY `goods_received_items_drug_id_batch_number_index` (`drug_id`,`batch_number`),
  ADD KEY `goods_received_items_expiry_date_index` (`expiry_date`);

--
-- Indexes for table `goods_received_notes`
--
ALTER TABLE `goods_received_notes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `goods_received_notes_grn_number_unique` (`grn_number`),
  ADD KEY `goods_received_notes_received_by_foreign` (`received_by`),
  ADD KEY `goods_received_notes_grn_number_index` (`grn_number`),
  ADD KEY `goods_received_notes_purchase_order_id_received_date_index` (`purchase_order_id`,`received_date`),
  ADD KEY `goods_received_notes_branch_id_status_index` (`branch_id`,`status`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_is_read_created_at_index` (`user_id`,`is_read`,`created_at`),
  ADD KEY `notifications_type_created_at_index` (`type`,`created_at`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_sale_id_index` (`sale_id`),
  ADD KEY `payments_payment_method_payment_date_index` (`payment_method`,`payment_date`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`),
  ADD KEY `permissions_name_index` (`name`),
  ADD KEY `permissions_module_index` (`module`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `purchase_orders_order_number_unique` (`order_number`),
  ADD KEY `purchase_orders_created_by_foreign` (`created_by`),
  ADD KEY `purchase_orders_approved_by_foreign` (`approved_by`),
  ADD KEY `purchase_orders_order_number_index` (`order_number`),
  ADD KEY `purchase_orders_supplier_id_status_order_date_index` (`supplier_id`,`status`,`order_date`),
  ADD KEY `purchase_orders_branch_id_status_index` (`branch_id`,`status`),
  ADD KEY `purchase_orders_status_expected_delivery_date_index` (`status`,`expected_delivery_date`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_order_items_purchase_order_id_index` (`purchase_order_id`),
  ADD KEY `purchase_order_items_drug_id_index` (`drug_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`),
  ADD KEY `roles_name_index` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_permissions_role_id_permission_id_unique` (`role_id`,`permission_id`),
  ADD KEY `role_permissions_permission_id_index` (`permission_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_sale_number_unique` (`sale_number`),
  ADD KEY `sales_approved_by_pharmacist_foreign` (`approved_by_pharmacist`),
  ADD KEY `sales_sale_number_index` (`sale_number`),
  ADD KEY `sales_branch_id_sale_date_index` (`branch_id`,`sale_date`),
  ADD KEY `sales_user_id_sale_date_index` (`user_id`,`sale_date`),
  ADD KEY `sales_customer_phone_index` (`customer_phone`),
  ADD KEY `sales_prescription_number_index` (`prescription_number`),
  ADD KEY `sales_discount_authorized_by_foreign` (`discount_authorized_by`);

--
-- Indexes for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_items_sale_id_index` (`sale_id`),
  ADD KEY `sale_items_stock_item_id_index` (`stock_item_id`),
  ADD KEY `sale_items_drug_id_index` (`drug_id`);

--
-- Indexes for table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sale_returns_return_number_unique` (`return_number`),
  ADD KEY `sale_returns_branch_id_foreign` (`branch_id`),
  ADD KEY `sale_returns_processed_by_foreign` (`processed_by`),
  ADD KEY `sale_returns_authorized_by_foreign` (`authorized_by`),
  ADD KEY `sale_returns_sale_id_return_date_index` (`sale_id`,`return_date`),
  ADD KEY `sale_returns_return_number_index` (`return_number`);

--
-- Indexes for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_return_items_sale_return_id_foreign` (`sale_return_id`),
  ADD KEY `sale_return_items_sale_item_id_foreign` (`sale_item_id`),
  ADD KEY `sale_return_items_stock_item_id_foreign` (`stock_item_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `stock_items`
--
ALTER TABLE `stock_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_batch_per_branch` (`drug_id`,`branch_id`,`batch_number`),
  ADD KEY `stock_items_branch_id_expiry_date_index` (`branch_id`,`expiry_date`),
  ADD KEY `stock_items_drug_id_quantity_available_index` (`drug_id`,`quantity_available`),
  ADD KEY `stock_items_expiry_date_index` (`expiry_date`);

--
-- Indexes for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_movements_stock_item_id_movement_date_index` (`stock_item_id`,`movement_date`),
  ADD KEY `stock_movements_user_id_movement_date_index` (`user_id`,`movement_date`),
  ADD KEY `stock_movements_reference_type_reference_id_index` (`reference_type`,`reference_id`),
  ADD KEY `stock_movements_movement_type_movement_date_index` (`movement_type`,`movement_date`);

--
-- Indexes for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `stock_transfers_transfer_number_unique` (`transfer_number`),
  ADD KEY `stock_transfers_requested_by_foreign` (`requested_by`),
  ADD KEY `stock_transfers_approved_by_foreign` (`approved_by`),
  ADD KEY `stock_transfers_transfer_number_index` (`transfer_number`),
  ADD KEY `stock_transfers_from_branch_id_status_index` (`from_branch_id`,`status`),
  ADD KEY `stock_transfers_to_branch_id_status_index` (`to_branch_id`,`status`),
  ADD KEY `stock_transfers_status_transfer_date_index` (`status`,`transfer_date`);

--
-- Indexes for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_transfer_items_drug_id_foreign` (`drug_id`),
  ADD KEY `stock_transfer_items_stock_transfer_id_index` (`stock_transfer_id`),
  ADD KEY `stock_transfer_items_stock_item_id_index` (`stock_item_id`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subcategories_category_id_slug_unique` (`category_id`,`slug`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `suppliers_is_active_index` (`is_active`),
  ADD KEY `suppliers_name_index` (`name`);

--
-- Indexes for table `system_configs`
--
ALTER TABLE `system_configs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `system_configs_key_unique` (`key`),
  ADD KEY `system_configs_group_index` (`group`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_branch_id_foreign` (`branch_id`),
  ADD KEY `users_email_index` (`email`),
  ADD KEY `users_role_id_branch_id_index` (`role_id`,`branch_id`),
  ADD KEY `users_deleted_at_index` (`deleted_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `drugs`
--
ALTER TABLE `drugs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1085;

--
-- AUTO_INCREMENT for table `goods_received_items`
--
ALTER TABLE `goods_received_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `goods_received_notes`
--
ALTER TABLE `goods_received_notes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `sale_returns`
--
ALTER TABLE `sale_returns`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `stock_items`
--
ALTER TABLE `stock_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_movements`
--
ALTER TABLE `stock_movements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=578;

--
-- AUTO_INCREMENT for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `system_configs`
--
ALTER TABLE `system_configs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `drugs`
--
ALTER TABLE `drugs`
  ADD CONSTRAINT `drugs_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `drugs_subcategory_id_foreign` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `goods_received_items`
--
ALTER TABLE `goods_received_items`
  ADD CONSTRAINT `goods_received_items_drug_id_foreign` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `goods_received_items_grn_id_foreign` FOREIGN KEY (`grn_id`) REFERENCES `goods_received_notes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `goods_received_notes`
--
ALTER TABLE `goods_received_notes`
  ADD CONSTRAINT `goods_received_notes_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `goods_received_notes_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`),
  ADD CONSTRAINT `goods_received_notes_received_by_foreign` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `purchase_orders_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `purchase_orders_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `purchase_orders_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `purchase_order_items_drug_id_foreign` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `purchase_order_items_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_approved_by_pharmacist_foreign` FOREIGN KEY (`approved_by_pharmacist`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sales_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `sales_discount_authorized_by_foreign` FOREIGN KEY (`discount_authorized_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sales_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_drug_id_foreign` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `sale_items_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sale_items_stock_item_id_foreign` FOREIGN KEY (`stock_item_id`) REFERENCES `stock_items` (`id`);

--
-- Constraints for table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD CONSTRAINT `sale_returns_authorized_by_foreign` FOREIGN KEY (`authorized_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sale_returns_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `sale_returns_processed_by_foreign` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sale_returns_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`);

--
-- Constraints for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  ADD CONSTRAINT `sale_return_items_sale_item_id_foreign` FOREIGN KEY (`sale_item_id`) REFERENCES `sale_items` (`id`),
  ADD CONSTRAINT `sale_return_items_sale_return_id_foreign` FOREIGN KEY (`sale_return_id`) REFERENCES `sale_returns` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sale_return_items_stock_item_id_foreign` FOREIGN KEY (`stock_item_id`) REFERENCES `stock_items` (`id`);

--
-- Constraints for table `stock_items`
--
ALTER TABLE `stock_items`
  ADD CONSTRAINT `stock_items_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `stock_items_drug_id_foreign` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

--
-- Constraints for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD CONSTRAINT `stock_movements_stock_item_id_foreign` FOREIGN KEY (`stock_item_id`) REFERENCES `stock_items` (`id`),
  ADD CONSTRAINT `stock_movements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD CONSTRAINT `stock_transfers_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `stock_transfers_from_branch_id_foreign` FOREIGN KEY (`from_branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `stock_transfers_requested_by_foreign` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `stock_transfers_to_branch_id_foreign` FOREIGN KEY (`to_branch_id`) REFERENCES `branches` (`id`);

--
-- Constraints for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD CONSTRAINT `stock_transfer_items_drug_id_foreign` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `stock_transfer_items_stock_item_id_foreign` FOREIGN KEY (`stock_item_id`) REFERENCES `stock_items` (`id`),
  ADD CONSTRAINT `stock_transfer_items_stock_transfer_id_foreign` FOREIGN KEY (`stock_transfer_id`) REFERENCES `stock_transfers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
