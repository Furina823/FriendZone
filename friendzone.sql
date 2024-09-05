-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 20, 2024 at 09:02 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `friendzone`
--
CREATE DATABASE IF NOT EXISTS `friendzone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `friendzone`;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(4) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `profile_picture` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `username`, `email`, `password`, `phone`, `address`, `profile_picture`) VALUES
(1, 'FriendZone', 'friendzonefun24@gmail.com', 'abcd1234', '+60 3-2301 8888', 'Level 10, Wisma UOA II, 21 Jalan Pinang, Kuala Lumpur City Centre, 50450 Kuala Lumpur, Malaysia', 'logo1.png');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `attendance_id` int(4) NOT NULL,
  `event_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`attendance_id`, `event_id`, `user_id`) VALUES
(1, 11, 27),
(2, 11, 31),
(3, 11, 28),
(4, 11, 5),
(5, 9, 40),
(6, 9, 35),
(7, 9, 32),
(8, 9, 34),
(9, 10, 37),
(10, 10, 10),
(11, 10, 11),
(12, 10, 40),
(13, 10, 32),
(14, 10, 15),
(15, 10, 18),
(32, 14, 40),
(33, 14, 40),
(34, 15, 40);

-- --------------------------------------------------------

--
-- Table structure for table `business`
--

CREATE TABLE `business` (
  `business_id` int(4) NOT NULL,
  `company_name` varchar(200) NOT NULL,
  `industry` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `address` text NOT NULL,
  `profile_picture` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business`
--

INSERT INTO `business` (`business_id`, `company_name`, `industry`, `email`, `password`, `phone_number`, `address`, `profile_picture`) VALUES
(1, 'IBM Malaysia Sdn. Bhd.', 'IT', 'direct@my.ibm.com', 'abcd1234', '+60 3-2301 8888', 'IBM Malaysia Sdn. Bhd. Level 19, Plaza IBM, No. 8 First Avenue, Bangsar South, 59200 Kuala Lumpur, Malaysia', 'ibm.jpg'),
(2, 'Exabytes', 'IT', 'support@exabytes.my', 'abcd1234', '+60 4-630 8283', '1-18-8 Suntech @ Penang Cybercity, Lintang Mayang Pasir 3, 11950 Bayan Baru, Penang, Malaysia', 'exabytes.png'),
(4, 'Silverlake Group', 'IT', 'info@silverglobe.com', 'abcd1234', '+60 3-7490 5888', 'Level 2, Tower 1, Avenue 3, Bangsar South City, No. 8 Jalan Kerinchi, 59200 Kuala Lumpur, Malaysia', 'silverlake.png'),
(5, 'Hewlett-Packard (HP) Malaysia', 'IT', 'info@hp.com.my', 'abcd1234', '+60 3-2332 3333', 'Menara HP, 12 Jalan Gelenggang, Bukit Damansara, 50490 Kuala Lumpur, Malaysia', 'hp.png'),
(6, 'Microsoft Malaysia', 'IT', 'microsoft.com', 'abcd1234', '+60 3-2267 8000', 'Level 18, 2, Jalan Stesen Sentral 5, Kuala Lumpur Sentral, 50470 Kuala Lumpur, Malaysia', 'microsoft.jpg'),
(7, 'Maybank', 'Finance', 'community@maybank.com', 'abcd1234', '+60 3-2070 8833', 'Menara Maybank, 100 Jalan Tun Perak, 50050 Kuala Lumpur, Malaysia', 'mb.jpg'),
(8, 'CIMB Group', 'Finance', 'community@cimb.com', 'abcd1234', '+60 3-2261 8888', 'Menara CIMB, Jalan Stesen Sentral 2, Kuala Lumpur Sentral, 50470 Kuala Lumpur, Malaysia', 'cimb.png'),
(9, 'Public Bank', 'Finance', 'community@publicbank.com.my', 'abcd1234', '+60 3-2176 6000', 'Menara Public Bank, 146 Jalan Ampang, 50450 Kuala Lumpur, Malaysia', 'pb.png'),
(10, 'RHB Bank', 'Finance', 'community@rhbgroup.com', 'abcd1234', '+60 3-9287 8888', 'Level 10, Tower 1, RHB Centre, Jalan Tun Razak, 50400 Kuala Lumpur, Malaysia', 'rhb.jpg'),
(11, 'Hong Leong Bank', 'Finance', 'community@hlbb.hongleong.com.my', 'abcd1234', '+60 3-2081 8888', 'Level 9, Wisma Hong Leong, 18 Jalan Perak, 50450 Kuala Lumpur, Malaysia', 'hongleong.png'),
(12, 'Women\'s Aid Organisation (WAO)', 'Social', 'wao@wao.org.my', 'abcd1234', '+60 3-7957 5636', 'P.O. Box 493, Jalan Sultan 46760 Petaling Jaya, Selangor, Malaysia', 'wao.png'),
(13, 'Persatuan Kesedarab Komuniti Selangor (EMPOWER)', 'Social', 'info@empowermalaysia.org', 'abcd1234', '+60 3-7784 4977', '13, Lorong 4/48A, 46050 Petaling Jaya, Selangor, Malaysia', 'empower.png'),
(14, 'SOLS 24/7', 'Social', 'info@sols247.org', 'abcd1234', '+60 3-9054 1928', '31-3-1, Block H, Jalan 2/101C, Cheras Business Centre, 56100 Kuala Lumpur, Malaysia', 'sols.png'),
(15, 'Bersih 2.0', 'Social', 'info@bersih.org', 'abcd1234', '+60 3-7931 4444', '10-2, Jalan Bangsar Utama 9, Bangsar Utama, 59000 Kuala Lumpur, Malaysia', 'bersih.png'),
(16, 'Make-A-Wish Malaysia', 'Social', 'info@makeawish.org.my', 'abcd1234', '+60 3-9281 4038', 'B-12-11, Megan Avenue II, 12 Jalan Yap Kwan Seng, 50450 Kuala Lumpur, Malaysia', 'make_a_wish.jpg'),
(17, 'Sunway Medical Centre', 'Medicine', 'info@sunwaymedical.com', 'abcd1234', '+60 3-7491 9191', '5, Jalan Lagoon Selatan, Bandar Sunway, 47500 Subang Jaya, Selangor, Malaysia', 'sunway.png'),
(18, 'Pantai Hospital Kuala Lumpur', 'Medicine', 'info@pantai.com.my', 'abcd1234', '+60 3-2296 0888', '8, Jalan Bukit Pantai, 59100 Kuala Lumpur, Malaysia', 'pantai.jpg'),
(19, 'Gleneagles Kuala Lumpur', 'Medicine', 'info@gleneagleskl.com.my\r\n', 'abcd1234', '+60 3-4141 3000', '286 & 288, Jalan Ampang, 50450 Kuala Lumpur, Malaysia', 'gleneagles.png'),
(20, 'KPJ Healthcare Berhad', 'Medicine', 'info@kpjhealth.com.my', 'abcd1234', '+60 3-2681 6222', 'Level 20, Menara 238, Jalan Tun Razak, 50400 Kuala Lumpur, Malaysia', 'kpj.png'),
(21, 'Columbia Asia Hospital', 'Medicine', 'info@columbiaasia.com', 'abcd1234', '+60 3-5521 5151', 'No. 1, Jalan 13/1, Section 13, 46200 Petaling Jaya, Selangor, Malaysia', 'columbia.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `chat_participant`
--

CREATE TABLE `chat_participant` (
  `chat_id` int(4) NOT NULL,
  `friend_id` int(4) NOT NULL,
  `friend_id_2` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_participant`
--

INSERT INTO `chat_participant` (`chat_id`, `friend_id`, `friend_id_2`) VALUES
(8, 5, 7),
(9, 6, 8),
(26, 9, 10);

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `comment_id` int(4) NOT NULL,
  `post_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL,
  `comment_text` text NOT NULL,
  `date_time` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`comment_id`, `post_id`, `user_id`, `comment_text`, `date_time`) VALUES
(1, 56, 28, 'Nice Elephant! very cuteeee!!!!!!', '2025-05-24 10:21:15.000000'),
(2, 55, 34, 'sunny beach yayyyy!!!', '2025-06-28 11:21:15.000000'),
(4, 2, 28, 'bad vibes shoooo!!!', '2024-07-09 16:25:37.000000'),
(5, 2, 7, 'Nah, you bad bad!!!', '2024-07-16 03:25:37.000000'),
(6, 2, 10, 'Woiii, no good no good', '2024-07-30 21:26:24.000000'),
(7, 2, 32, 'Lah lah lah lah lah.....', '2024-08-09 04:27:24.000000'),
(8, 2, 35, 'I know u good larhhh!!!', '2024-08-22 08:27:24.000000'),
(9, 2, 35, 'vibe vibe vibe~~~~~', '2024-09-14 19:44:30.000000'),
(10, 2, 12, 'I love You!!!!!', '2024-09-20 19:46:16.000000'),
(11, 2, 29, 'Eii, where is this?', '2024-09-30 19:58:18.000000'),
(12, 5, 13, 'Aiyorrr!!! why so careless?🤣', '2024-07-23 13:19:42.092475'),
(13, 5, 16, 'Yeeee', '2024-07-23 13:20:01.367235'),
(14, 1, 11, 'bookworm oii!', '2024-07-23 13:27:09.108666'),
(15, 1, 26, 'ok larh ok larh go read', '2024-07-23 13:28:41.437794'),
(16, 1, 20, 'sleep sleep', '2024-07-23 13:30:17.228997'),
(17, 1, 24, 'woii, study for what?', '2024-07-23 13:35:53.466958'),
(18, 1, 15, 'go sleep!', '2024-07-23 13:38:32.530896'),
(19, 1, 24, 'go sleep!', '2024-07-23 13:41:15.835311'),
(20, 1, 40, 'no more reading books!', '2024-07-24 12:32:16.537539'),
(21, 1, 40, 'go away from library!', '2024-07-24 12:35:47.650619'),
(23, 28, 62, 'so green!', '2024-08-19 14:47:52.392824');

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `event_id` int(4) NOT NULL,
  `business_id` int(4) NOT NULL,
  `title` text NOT NULL,
  `created_date` date NOT NULL DEFAULT current_timestamp(),
  `quote` text NOT NULL,
  `media` text NOT NULL,
  `date_time` varchar(30) NOT NULL,
  `location` text NOT NULL,
  `overview` text NOT NULL,
  `objectives` text DEFAULT NULL,
  `target_audience` text DEFAULT NULL,
  `structure` text DEFAULT NULL,
  `material` text DEFAULT NULL,
  `benefit` text DEFAULT NULL,
  `link` text DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `qr_code` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`event_id`, `business_id`, `title`, `created_date`, `quote`, `media`, `date_time`, `location`, `overview`, `objectives`, `target_audience`, `structure`, `material`, `benefit`, `link`, `status`, `qr_code`) VALUES
(1, 1, 'Digital Transformation Conference', '2023-01-10', 'Embrace the digital revolution', '1.jpg', '2023-08-15 09:00-17:00', 'Kuala Lumpur Convention Centre, Kuala Lumpur, Malaysia', 'A conference exploring the latest trends and innovations in digital transformation.', 'Educate participants on the impact of digital technologies;Share strategies for implementing digital transformations', 'Business leaders;IT professionals;Digital strategists', 'Keynote sessions by industry leaders;Panel discussions on digital transformation;Breakout workshops for hands-on learning', 'Conference booklet;Access to presentation slides', 'Gain insights from industry leaders, network with peers.', NULL, 'past', 'event_1.png'),
(2, 7, 'Financial Modelling Workshop', '2023-02-20', 'Empower your future with financial knowledge', '2.jpg', '2023-09-20 10:00-16:00', 'Sunway University, Selangor, Malaysia', 'A workshop aimed at equipping participants with financial modelling skills.', 'Understand fundamental concepts of financial modelling;Build comprehensive financial models from scratch;Apply models to real-world scenarios', 'Financial analysts;Investment bankers;Corporate finance professionals', 'Introduction to financial modelling;Excel for financial modelling;Building a financial model;Advanced modelling techniques;Real-world applications;Presentation & intepretation of results', 'Workbook;Excel templates;Case studies', 'Enhance financial modelling skills;Improve Excel proficiency', NULL, 'past', 'event_2.png'),
(3, 20, 'Healthcare Innovation Competition', '2023-03-15', 'Innovate for a healthier future.', '3.jpg', '2023-12-01 10:00-18:00', 'University of Malaya, Kuala Lumpur, Malaysia', 'A competition encouraging innovative solutions in healthcare.', 'Foster creativity and problem-solving in healthcare;Showcase innovative healthcare solutions', 'Medical students;Healthcare professionals;Innovators', NULL, NULL, NULL, NULL, 'past', 'event_3.png'),
(4, 16, 'Social Media Marketing Seminar', '2023-04-10', '\"Master the art of social media.', '4.jpg', '2023-11-10 09:00-15:00', 'Taylor\'s University, Selangor, Malaysia', 'A seminar on effective social media marketing strategies.', 'Provide actionable insights for social media marketing.', NULL, NULL, NULL, NULL, NULL, 'rejected', 'event_4.png'),
(5, 2, 'Cybersecurity Workshop', '2023-05-05', 'Stay secure in a digital world.', '5.jpg', '2023-10-05 09:00-17:00', 'Universiti Teknologi Malaysia, Johor, Malaysia', 'A workshop on the latest cybersecurity practices and technologies.', 'Educate participants on cybersecurity threats and solutions;Provide hands-on training in cybersecurity tools', 'IT professionals;Cybersecurity enthusiasts', 'Introduction to cybersecurity;Hands-on sessions with cybersecurity tools;Case studies on cybersecurity incidents', 'Workshop booklet;Software tools', 'Enhanced cybersecurity skills;Knowledge of the latest threats', NULL, 'past', 'event_5.png'),
(6, 9, 'Investment Strategies Seminar', '2023-06-01', 'Invest smart, grow wealth', '6.jpg', '2023-11-01 10:00-16:00', 'Universiti Putra Malaysia, Selangor, Malaysia', 'A seminar on effective investment strategies.', 'Teach various investment strategies;Help participants make informed investment decisions', 'Investors;Financial advisors;Students', 'Introduction to investment strategies;Case studies on successful investments;Panel discussion with investment experts', NULL, NULL, NULL, 'past', 'event_6.png'),
(7, 18, 'Medical Research Workshop', '2023-07-10', 'Advancing medical research for a better tomorrow.', '7.jpg', '2024-02-10 09:00-17:00', 'Universiti Sains Malaysia, Penang, Malaysia', 'A workshop on the latest techniques in medical research.', NULL, 'Medical researchers;Students;Healthcare professionals', NULL, NULL, NULL, NULL, 'past', 'event_7.png'),
(8, 13, 'Community Development Seminar', '2023-08-15', 'Building stronger communities together.', '8.jpg', '2024-03-15 10:00-15:00', 'University of Nottingham Malaysia, Selangor, Malaysia', 'A seminar on strategies for effective community development.', 'Share best practices in community development;Foster collaboration among community leaders', 'Community leaders;Social workers;Students', NULL, 'Seminar handouts;Community development resources', 'Improved community development skills;Networking opportunities', NULL, 'rejected', 'event_8.png'),
(9, 5, 'Blockchain Technology Workshop', '2023-09-01', 'Unlock the potential of blockchain.', '9.jpg', '2024-04-01 09:00-17:00', 'Asia Pacific University, Kuala Lumpur, Malaysia', 'A workshop on blockchain technology and its applicaitons.', NULL, 'IT professionals;Blockchain enthusiasts', NULL, NULL, NULL, NULL, 'past', 'event_9.png'),
(10, 8, 'Personal Finance Workshop', '2023-10-05', 'Take control of your finances.', '10.jpg', '2024-05-05 10:00-16:00', 'Universiti Teknologi MARA, Selangor, Malaysia', 'A workshop on mananing personal finances.', NULL, NULL, NULL, NULL, 'Improved personal finance skills;Practical financial strategies', NULL, 'past', 'event_10.png'),
(11, 21, 'Public Health Seminar', '2023-11-10', 'Promoting health for all.', '11.jpg', '2024-06-10 09:00-17:00', 'Universiti Malaya, Kuala Lumpur, Malaysia', 'A seminar on public health strategies and policies.', 'Educate participants on public health issues and solutions;Share recent advancements in public health', 'Public health professionals;Students;Policymakers', 'Keynote speeches by public health experts;Panel discussions on public health challenges;Workshops on public health strategies', NULL, NULL, NULL, 'past', 'event_11.png'),
(12, 6, 'Digital Marketing Workshop', '2023-12-05', 'Boost your digital presence', '12.jpg', '2024-07-20 09:00-17:00', 'Taylor\'s University, Selangor, Malaysia', 'A workshop on effective digital marketing strategies.', 'Teach participants the basics of digital marketing;Provide strategies for creating engaging digital content', 'Marketing professionals;Small business owners;Students', NULL, NULL, NULL, NULL, 'upcoming', 'event_12.png'),
(13, 11, 'Financial Planning Seminar', '2024-01-10', 'Plan for a secure financial future.', '13.jpg', '2024-08-10 10:00-16:00', 'Universiti Putra Malaysia, Selangor, Malaysia', 'A seminar on financial planning strategies.', NULL, 'Financial advisors;Students;Anyone interested in financial planning', 'Introduction to financial planning;Budgeting and saving strategies;Investment and retirement planning', 'Seminar notes;Financial planning templates', 'Improved financial planning skills;Practical strategies', NULL, 'upcoming', 'event_13.png'),
(14, 12, 'Mental Health Workshop', '2024-02-15', 'Prioritize your mental well-being.', '14.jpg', '2024-09-15 10:00-15:00', 'University of Nottingham Malaysia, Selangor, Malaysia', 'A workshop on mental health awareness and strategies.', 'Educate participants on mental health issues.', 'Students;Professionals;Anyone interested in mental health', 'Introduction to mental health;Workshops on mental health strategies;Panel discussions on mental health challenges', 'Workshop booklet;Mental health resources', 'Enhanced mental health knowledge,practical strategies', NULL, 'upcoming', 'event_14.png'),
(15, 2, 'Big Data Analytics Conference', '2024-03-10', 'Harness the power of big data.', '15.jpg', '2024-10-10 09:00-17:00', 'Asia Pacific University, Kuala Lumpur, Malaysia', 'A conference on the latest trends in big data analytics.', 'Share knowledge and developments in big data analytics;Provide hands-on training in big data tools', 'Data analysts;IT professionals;Researchers', NULL, NULL, 'Enhanced big data analytics skills;Networking opportunities', NULL, 'upcoming', 'event_15.png'),
(16, 19, 'Medical Ethics Seminar', '2024-04-15', 'Ethics in medicine: A guiding principle.', '16.jpg', '2024-11-15 09:00-17:00', 'Universiti Malaya, Kuala Lumpur, Malaysia', 'A seminar on medical ethics and its importance in healthcare.', NULL, NULL, NULL, NULL, NULL, NULL, 'rejected', 'event_16.png'),
(17, 14, 'Social Entrepreneurship Workshop', '2024-05-10', 'Creating impact through entrepreneurship.', '17.jpg', '2024-12-10 09:00-17:00', 'Taylor\'s University, Selangor, Malaysia', 'A workshop on social entrepreneurship and creating social impact.', 'Teach participants the basics of social entrepreneurship;Provide strategies for creating social impact through business', 'Aspiring social entrepreneurs;Students;Professionals', NULL, NULL, NULL, NULL, 'upcoming', 'event_17.png'),
(18, 4, 'Artificial Intelligence Workshop', '2024-06-20', 'Transform the future with AI.', '18.jpg', '2024-12-15 09:00-17:00', 'Asia Pacific University, Kuala Lumpur, Malaysia', 'A workshop on the latest techniques in artificial intelligence.', 'Teach participants the basics of artificial intelligence;Provide hands-on training in AI tools and techniques.', 'IT professionals;AI enthusiasts;Students', NULL, 'Workshop booklet;Software tools', 'Enhanced AI skills;Practical strategies', NULL, 'requested', 'event_18.png'),
(19, 10, 'Investment Banking Competition', '2024-07-01', 'Compete, Innovate, Excel.', '19.jpg', '2025-01-20 09:00-18:00', 'Universiti Putra Malaysia, Selangor, Malaysia', 'A competition for aspiring investment bankers to showcase their skills.', 'Encourage innovation and excellence in investment banking;Provide a platform for showcasing talent', 'Investment banking students;Professionals;Enthusiasts', '', '', '', NULL, 'requested', 'event_19.png'),
(20, 15, 'Public Speaking Workshop', '2024-07-20', 'Speak with Confidence!', '20.jpg', '2025-02-15 09:00-17:00', 'University of Nottingham Malaysia, Selangor, Malaysia', 'A workshop on improving public speaking skills.', 'Teach participants the basics of public speaking;Provide strategies for effective communication', 'Students;Professionals;Anyone interested in public speaking', NULL, NULL, NULL, NULL, 'requested', 'event_20.png');

-- --------------------------------------------------------

--
-- Table structure for table `friend`
--

CREATE TABLE `friend` (
  `friend_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL,
  `user_id_2` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friend`
--

INSERT INTO `friend` (`friend_id`, `user_id`, `user_id_2`) VALUES
(7, 1, 40),
(8, 10, 40),
(9, 33, 40),
(5, 40, 1),
(6, 40, 10),
(10, 40, 33);

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `message_id` int(10) NOT NULL,
  `chat_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL,
  `message_text` text NOT NULL,
  `date_time` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`message_id`, `chat_id`, `user_id`, `message_text`, `date_time`) VALUES
(5, 8, 1, 'Ish', '2024-08-18 17:11:39.000000'),
(6, 8, 40, 'What?', '2024-08-18 17:15:39.000000'),
(7, 9, 40, 'Hello!', '2024-08-18 11:12:36.000000'),
(8, 9, 10, 'I love you!', '2024-08-18 12:14:36.000000'),
(9, 9, 40, 'Yorrr! What happen?', '2024-08-18 13:22:18.087992'),
(10, 9, 40, 'Cakap cakap faster apa sai?', '2024-08-18 13:34:13.531563'),
(11, 9, 40, 'u want to go event or not btw?', '2024-08-18 13:36:45.044033'),
(12, 9, 40, 'huh?', '2024-08-18 13:39:57.127952'),
(13, 9, 10, 'i go!', '2024-08-18 14:11:43.638444'),
(14, 9, 10, 'i want to go! i say', '2024-08-18 14:13:35.781668'),
(15, 9, 40, 'ok, i drive u isit?', '2024-08-18 14:15:13.399610'),
(16, 9, 10, 'yaya, can?', '2024-08-18 14:15:51.322925'),
(17, 9, 40, 'boleh, see u tmr!', '2024-08-18 14:16:23.080109'),
(18, 9, 40, 'i come at 9', '2024-08-18 14:17:47.562035'),
(19, 8, 40, 'u want someone to punch u isit?', '2024-08-18 17:18:37.856051'),
(24, 26, 40, 'Hello!', '2024-08-19 12:43:25.598262');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `token_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `token` varchar(100) NOT NULL,
  `expiration_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`token_id`, `email`, `token`, `expiration_time`) VALUES
(0, 'xcloh1101@g', '125290bbe9d382538884111b2e19cdb9', '2024-08-15 21:28:27'),
(0, 'xcloh1101@g', '0c6948616dfa963634279db2b86ea5ac', '2024-08-15 21:31:33');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `post_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL,
  `post_media` text DEFAULT NULL,
  `post_text` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `date_time` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`post_id`, `user_id`, `post_media`, `post_text`, `location`, `date_time`) VALUES
(1, 27, '1.jpg', 'The life in a small library~~', NULL, '2024-07-12 14:11:36.000000'),
(2, 40, '2.jpg', 'Good Vibes ONLY!', 'Kuala Lumpur', '2024-04-17 21:12:47.000000'),
(3, 37, '3.jpg', 'Blue sky, blue wind, blue mountains, blue water, everything is BLUE!', 'Bayan Lepas, Penang', '2024-01-09 08:29:18.000000'),
(4, 1, '4.jpg', 'I love you, you love me~~', NULL, '2024-04-03 16:24:00.000000'),
(5, 28, '5.jpg', 'Drumstick sudah patah :(', NULL, '2024-06-04 10:39:55.000000'),
(6, 2, '6.jpg', 'If there is no silver, I would be searching it for a whole month and still can\'t find it!', 'Putrajaya', '2024-04-10 13:16:49.000000'),
(7, 3, '7.jpg', 'A whole night party again!', 'Cyberjaya', '2024-04-02 02:22:36.000000'),
(8, 38, '8.jpg', 'drink Drink.....', 'Puchong', '2024-05-15 16:19:01.000000'),
(9, 29, '9.jpg', 'i knew u were trouble when u walked in~~~', NULL, '2024-02-15 19:12:25.000000'),
(10, 30, '10.jpg', 'traffic==in the phone :D', 'Kajang', '2024-06-12 09:20:51.000000'),
(11, 4, '11.jpg', 'my heart is so empty~~ in the darkness~~ i\'m alone...', 'Bukit Jalil', '2024-07-03 23:54:51.000000'),
(12, 31, '12.jpg', 'under the tree!', NULL, '2024-05-08 12:22:39.000000'),
(13, 5, '13.jpg', 'under scientific construction!', 'Melaka', '2024-06-14 11:22:42.000000'),
(14, 6, '14.jpg', 'yellow, yellow weeeee~~~~~', NULL, '2024-07-09 17:24:32.000000'),
(15, 7, '15.jpg', 'ready to be CPU on FIRE', 'Petaling Jaya', '2024-07-09 13:24:32.000000'),
(16, 8, '16.jpg', 'yum Yum YUm YUMMMMMM!!!!', NULL, '2024-05-22 13:25:33.000000'),
(17, 9, '17.jpg', NULL, NULL, '2024-03-27 09:25:56.000000'),
(18, 10, '18.jpg', 'food THERAPY~', NULL, '2024-01-11 20:27:31.000000'),
(19, 36, '19.jpg', 'BEAUTIFULLLLL', NULL, '2024-04-30 11:27:31.000000'),
(20, 35, '20.jpg', NULL, NULL, '2024-06-27 23:30:15.000000'),
(21, 11, '21.jpg', 'peace of Malaysia :P', 'Batu Caves', '2024-07-25 06:30:15.000000'),
(22, 12, 'sample.mp4', 'Life is romantic, Romantic is life', NULL, '2024-05-22 10:31:45.000000'),
(23, 39, '22.jpg', 'Power of VR###', 'Bukit Jalil', '2024-07-27 13:15:36.000000'),
(24, 13, '23.jpg', 'DJ online!', NULL, '2024-07-22 03:46:18.000000'),
(25, 14, '24.jpg', 'Life of night just started!', 'Subang Jaya', '2024-07-30 22:33:09.000000'),
(26, 15, '25.jpg', 'FIRE~~~~', NULL, '2024-07-23 01:34:49.000000'),
(27, 16, '26.jpg', 'Night comes life~~', NULL, '2024-07-18 20:34:49.000000'),
(28, 33, '27.jpg', 'Green nature...', NULL, '2024-08-02 07:37:16.000000'),
(29, 17, '28.jpg', NULL, NULL, '2024-07-09 12:37:16.000000'),
(30, 18, '29.jpg', 'ART gallery Yay!', NULL, '2024-08-17 14:43:10.000000'),
(31, 19, '30.jpg', 'dream car coming~~', NULL, '2024-09-20 11:38:10.000000'),
(32, 34, '31.jpg', 'flora', NULL, '2024-07-09 07:39:17.000000'),
(33, 20, '32.jpg', 'Lantern festival!', 'Pudu', '2024-07-23 21:29:17.000000'),
(34, 21, '33.jpg', 'sky & cliff', NULL, '2024-07-15 06:40:21.000000'),
(35, 22, '34.jpg', 'hard work will pay off~~', 'Gombak', '2024-07-31 03:40:21.000000'),
(36, 23, '35.jpg', 'sea, sky, sky, sea', NULL, '2024-10-12 07:41:24.000000'),
(37, 32, '36.jpg', 'love u!', NULL, '2024-11-15 15:41:24.000000'),
(38, 24, '37.jpg', 'carsssss', NULL, '2024-10-26 14:42:30.000000'),
(39, 25, '38.jpg', NULL, NULL, '2024-11-23 19:46:30.000000'),
(40, 26, '39.jpg', 'live like a nature ppl', NULL, '2024-12-07 09:43:49.000000'),
(41, 40, '40.jpg', 'presentation again~~~', 'Bukit Jalil', '2024-12-20 11:48:49.000000'),
(42, 35, '41.jpg', 'i\'m still a baby!', NULL, '2024-12-21 10:44:59.000000'),
(43, 33, '42.jpg', 'best festival ever!', 'Bukit Jalil', '2024-12-27 08:44:59.000000'),
(44, 34, '43.jpg', 'error, error, ERROR!!!!', NULL, '2024-12-28 08:46:17.000000'),
(45, 32, '44.jpg', '', NULL, '2025-01-18 11:46:17.000000'),
(46, 27, '45.jpg', 'looking back at the old days', NULL, '2025-01-23 12:47:31.000000'),
(47, 2, '46.jpg', 'new car coming', NULL, '2025-02-12 19:47:31.000000'),
(48, 40, '47.jpg', 'sunset', NULL, '2025-02-20 17:48:33.000000'),
(49, 3, '48.jpg', NULL, NULL, '2025-02-22 10:48:58.000000'),
(50, 30, '49.jpg', 'fiveberry~~', NULL, '2025-02-27 10:36:10.000000'),
(51, 7, '50.jpg', 'BTS!!!!ARMY!!!!Woahhhh!!!', NULL, '2025-03-08 04:49:53.000000'),
(52, 9, '51.jpg', NULL, NULL, '2025-03-14 02:50:38.000000'),
(53, 19, '52.jpg', 'smile~~', NULL, '2025-03-20 10:50:38.000000'),
(54, 20, '53.jpg', 'red wine, wine red', NULL, '2025-03-27 16:51:31.000000'),
(55, 15, '54.jpg', 'beach!!', NULL, '2025-03-29 16:51:31.000000'),
(56, 35, '55.jpg', 'ELEPHANT!!!', 'Zoo Negara', '2025-04-03 14:52:23.000000'),
(57, 35, NULL, 'I love my life! GAMING!', NULL, '2025-04-05 01:53:21.000000'),
(60, 40, 'pexels-mdsnmdsnmdsn-1684880.jpg', '', 'Penang', '2024-07-27 15:09:01.614526'),
(63, 40, 'sample.mp4', 'Run run run', 'null', '2024-07-27 15:25:29.685783'),
(64, 40, 'null', 'I love u!', 'null', '2024-07-27 15:25:59.811501'),
(66, 40, 'null', 'I love science', 'Universiti Sains Malaysia', '2024-07-28 13:22:55.305011'),
(69, 62, 'pexels-clarango-3866555.jpg', 'Hello!', 'Johor Bahru', '2024-08-19 14:46:06.249538');

-- --------------------------------------------------------

--
-- Table structure for table `preference`
--

CREATE TABLE `preference` (
  `user_id` int(4) NOT NULL,
  `mbti` varchar(4) NOT NULL,
  `personality` text NOT NULL,
  `sport` text NOT NULL,
  `food` text NOT NULL,
  `fashion` text NOT NULL,
  `interest` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `preference`
--

INSERT INTO `preference` (`user_id`, `mbti`, `personality`, `sport`, `food`, `fashion`, `interest`) VALUES
(1, 'INFP', 'creative,compassionate,adventurous', 'tennis,swimming', 'italian', 'casual,bohemian,formal', 'books'),
(2, 'ENTJ', 'ambitious,intellectual', 'running', 'mexican,indian', 'formal', 'music,movies,theartre'),
(3, 'INTJ', 'analytical,ambitious', 'basketball,gym', 'japanese,vegan', 'minimalist,formal', 'books,photography'),
(4, 'ENFP', 'adventurous,creative,intellectual', 'martial arts', 'indian,mediterranean', 'vintage', 'travelling,books,cooking'),
(5, 'ESFP', 'outgoing,easygoing', 'football', 'mediterranean,thai', 'streetwear,hip-hop,minimalist', 'music,cooking,gaming'),
(6, 'ISTJ', 'analytical,easygoing', 'basketball,running,swimming', 'chinese,thai', 'casual,preppy,streetwear', 'movies,books,music'),
(7, 'ESTP', 'outgoing,adventurous', 'football,basketball,gym', 'italian,mexican,chinese', 'streetwear,hip-hop,minimalist', 'gaming,travelling'),
(8, 'INTP', 'intellectual,analytical,creative', 'tennis,cycling', 'mediterranean', 'minimalist,casual', 'books'),
(9, 'ENFJ', 'compassionate,outgoing', 'swimming', 'japanese,chinese,thai', 'formal,preppy', 'travelling'),
(10, 'ISFP', 'ambitious,intellectual', 'running', 'chinese', 'formal', 'theatre,travelling,movies'),
(11, 'ENTJ', 'ambitious,intellectual', 'running', 'italian,chinese,thai', 'formal,hip-hop', 'music,cooking'),
(12, 'INFJ', 'compassionate,creative', 'swimming,basketball', 'vegan', 'vintage,casual', 'books,movies,photography'),
(13, 'ESFJ', 'outgoing,easygoing,adventurous', 'tennis,gym', 'japanese,indian,mexican', 'preppy,streetwear,formal', 'music,cooking'),
(14, 'ISTP', 'analytical', 'football,cycling', 'thai', 'hip-hop', 'gaming'),
(15, 'ENFP', 'adventurous,creative,outgoing', 'running,martial arts', 'italian', 'vintage,casual', 'travelling,music'),
(16, 'ESTJ', 'ambitious', 'basketball,gym', 'chinese', 'formal,preppy', 'books,theatre'),
(17, 'INFP', 'creative,compasionate,analytic', 'swimming,gym', 'japanese,indian,chinese', 'casual,formal,bohemian', 'music'),
(18, 'ISFJ', 'easygoing', 'gym', 'thai,mexican', 'minimalist', 'books'),
(19, 'ENTP', 'adventurous,outgoing', 'running,football', 'vegan', 'streetwear', 'gaming,travelling'),
(20, 'ESTP', 'outgoing', 'basketball,tennis,gym', 'italian,chinese,thai', 'casual', 'music,movies,theatre'),
(21, 'INTJ', 'analytical,intellectual,ambitious', 'swimming,gym', 'indian,thai', 'formal,minimalist', 'books,photography'),
(22, 'INFJ', 'compassionate,creative,intellectual', 'tennis', 'japanese,mediterranean', 'vintage,bohemian', 'music,cooking'),
(23, 'ISTJ', 'analytical,easygoing', 'football,cycling,gym', 'mexican,chinese,thai', 'minimalist', 'movies,travelling'),
(24, 'ENFP', 'adventurous', 'gym', 'italian,indian,chinese', 'streetwear,casual,preppy', 'music,photography'),
(25, 'ISFP', 'creative,compassionate,ambitious', 'swimming,running,gym', 'mediterranean', 'vintage', 'theatre,cooking'),
(26, 'ENTJ', 'ambitious', 'football,martial arts', 'japanese,chinese', 'formal,bohemian', 'books,travelling'),
(27, 'ENFJ', 'outgoing,compassionate', 'basketball,tennis,swimming', 'italian,vegan,chinese', 'casual', 'music,theatre'),
(28, 'ISTP', 'adventurous,analytical,intellectual', 'cycling,running,gym', 'indian', 'hip-hop,minimalist,formal', 'gaming,photography,music'),
(29, 'INFP', 'creative,compassionate,easygoing', 'swimming,tennis,gym', 'japanese', 'bohemian,vintage', 'music,books'),
(30, 'ESFP', 'outgoing,easygoing', 'football', 'chinese,thai', 'streetwear,preppy', 'movies'),
(31, 'INTJ', 'analytical,intellectual', 'running', 'vegan,chinese,italian', 'formal,minimalist,streetwear', 'books,travelling'),
(32, 'ENFP', 'adventurous,creative', 'swimming,running,gym', 'italian,indian,chinese', 'vintage,casual,formal', 'music,photography,movies'),
(33, 'ISFJ', 'easygoing,compassionate,ambitious', 'cycling,tennis,swimming', 'japanese,chinese,thai', 'minimalist,streetwear,vintage', 'theatre,cooking,gaming'),
(34, 'ENTP', 'outgoing,adventurous,compassionate', 'football,running,gym', 'mexican,thai,italian', 'streetwear,hip-hop', 'gaming,travelling,music'),
(35, 'INFJ', 'compassionate', 'basketball,swimming,gym', 'italian,vegan,chinese', 'vintage,casual', 'gaming'),
(36, 'ESTJ', 'ambitious,analytical', 'tennis', 'indian,mediterranean', 'formal', 'books,theatre'),
(37, 'INFP', 'creative,compassionate', 'running', 'japanese,chinese', 'casual', 'music,photography'),
(38, 'ESFJ', 'outgoing', 'football', 'thai', 'streetwear,preppy', 'movies,cooking'),
(39, 'INTJ', 'analytical,intellectual,compassionate', 'swimming,gym', 'mediterranean', 'minimalist', 'books'),
(40, 'ENFJ', 'outgoing,compassionate', 'tennis,gym', 'japanese,chinese', 'casual,formal', 'music,movies,theatre'),
(42, 'INFP', 'adventurous', 'football', 'italian', 'casual', 'music'),
(62, 'esfp', 'creative,compassionate', 'basketball,running,martialarts', 'mediterranean', 'bohemian,minimalist', 'theater,traveling'),
(63, 'istj', 'creative,compassionate', 'swimming,gym', 'italian,japanese', 'formal,minimalist', 'books,music');

-- --------------------------------------------------------

--
-- Table structure for table `request`
--

CREATE TABLE `request` (
  `request_id` int(4) NOT NULL,
  `user_id` int(4) NOT NULL,
  `user_id_2` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `request`
--

INSERT INTO `request` (`request_id`, `user_id`, `user_id_2`) VALUES
(5, 40, 2),
(6, 40, 6);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `review_id` int(4) NOT NULL,
  `user_id` int(4) DEFAULT NULL,
  `post_id` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`review_id`, `user_id`, `post_id`) VALUES
(19, NULL, 46),
(24, NULL, 28),
(26, 33, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(4) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `current_state` varchar(100) DEFAULT NULL,
  `school` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `language` text DEFAULT NULL,
  `award` text DEFAULT NULL,
  `quote` text DEFAULT NULL,
  `profile_picture` text NOT NULL,
  `date_time` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `event_it` int(4) DEFAULT NULL,
  `event_medicine` int(4) DEFAULT NULL,
  `event_finance` int(4) DEFAULT NULL,
  `event_social` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `nickname`, `date_of_birth`, `gender`, `email`, `password`, `current_state`, `school`, `location`, `language`, `award`, `quote`, `profile_picture`, `date_time`, `event_it`, `event_medicine`, `event_finance`, `event_social`) VALUES
(1, 'Ash', '2000-01-15', 'male', 'ash@hotmail.com', 'abcd1234', 'Student', 'University Malaya', 'Kuala Lumpur', 'Malay', 'Best Developer Award', 'Innovation distinguishes between a leader and a follower.', '1.jpg', '2024-07-01 16:29:52.000000', 1, 3, NULL, NULL),
(2, 'Belle', '1995-02-20', 'female', 'belle@gmail.com', 'abcd1234', 'Social', 'Universiti Sains Malaysia', 'Penang', 'English', 'Community Hero Award', 'The best way to predict the future is to invent it.', '2.jpg', '2024-07-01 16:30:41.000000', NULL, NULL, 10, 8),
(3, 'Carl', '1998-03-05', 'male', 'carl@yahoo.com', 'abcd1234', 'Finance', 'Universiti Kebangsaan Malaysia', 'Selangor', 'Mandarin', 'Young Economist Award', 'Success is not the key to happiness. Happiness is the key to success.', '3.jpg', '2021-05-13 12:19:32.000000', NULL, NULL, NULL, NULL),
(4, 'Dani', '1990-04-12', 'female', 'dani@outlook.com', 'abcd1234', 'Medicine', 'Universiti Putra Malaysia', 'Serdang', 'Tamil', 'Outstanding Researcher Award', 'Health is the greatest gift.', '4.jpg', '2020-04-08 06:26:31.000000', 9, NULL, 13, 8),
(5, 'Ivan', '1985-05-23', 'male', 'evan@iCloud.com', 'abcd1234', 'IT', 'Universiti Teknologi Malaysia', 'Johor Bahru', 'Malay', 'Innovative Tech Award', 'Technology is best when it brings people together.', '5.jpg', '2024-06-13 16:43:41.000000', NULL, 16, 14, NULL),
(6, 'Faye', '1992-06-10', 'female', 'faye@mail.com', 'abcd1234', 'Social', 'Universiti Malaysia Sabah', 'Kota Kinabalu', 'English', 'Humanitarian Award', 'The purpose of life is to contribute in some way to making things better.', '6.jpg', '2021-05-12 16:46:16.000000', NULL, NULL, 10, NULL),
(7, 'Greg', '1988-07-27', 'male', 'greg@mail.com', 'abcd1234', 'Finance', 'Universiti Malaysia Sarawak', 'Kuching', 'Iban', 'Financial Planning Excellence', 'Financial freedom is available to those who learn about it and work for it.', '7.jpg', '2020-02-18 16:47:41.000000', NULL, 7, NULL, NULL),
(8, 'Hana', '1997-08-14', 'female', 'hana@hotmail.com', 'abcd1234', 'Student', 'Universiti Teknologi MARA', 'Shah Alam', 'Malay', 'Medical Innovation Award', 'The greatest wealth is health.', '8.jpg', '2021-10-14 11:00:22.000000', NULL, NULL, NULL, 8),
(9, 'Ian', '2002-09-09', 'male', 'ian@gmail.com', 'abcd1234', 'Student', 'Universiti Pendidikan Sultan Idris', 'Tanjung Malim', 'English', 'Tech Visionary Award', 'The future belongs to those who believe in the beauty of their dreams.', '9.jpg', '2021-09-24 16:50:47.000000', NULL, 3, NULL, NULL),
(10, 'Jade', '1986-10-22', 'female', 'jade@yahoo.com', 'abcd1234', NULL, 'Universiti Utara Malaysia', NULL, 'Thai', NULL, 'Service to others is the rent you pay for your room here on Earth.', '10.jpg', '2021-05-12 05:59:27.000000', NULL, NULL, 13, NULL),
(11, 'Kyle', '1991-11-19', 'male', 'kyle@outlook.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '11.jpg', '2020-07-10 23:36:21.000000', NULL, NULL, NULL, NULL),
(12, 'Lily', '1996-12-08', 'female', 'lily@outlook.com', 'abcd1234', 'Medicine', NULL, 'Subang Jaya', 'English', 'Healthcare Excellence Award', NULL, '12.jpg', '2021-07-06 10:48:00.000000', 9, NULL, NULL, NULL),
(13, 'Lexus', '1989-01-13', 'male', 'max@iCloud.com', 'abcd1234', 'IT', 'Sunway University', 'Petaling Jaya', NULL, '', NULL, '13.jpg', '2022-01-14 04:50:28.000000', 5, 3, NULL, NULL),
(14, 'Nora', '1993-02-28', 'female', 'nora@mail.com', 'abcd1234', 'Social', 'Universiti Tunku Abdul Rahman', 'Kuala Lumpur', NULL, NULL, NULL, '14.jpg', '2022-01-24 11:49:27.000000', 1, 3, 10, 4),
(15, 'Owen', '1995-03-15', 'male', 'owen@gmail.com', 'abcd1234', 'Finance', 'INTI International University', NULL, 'Malay', NULL, 'Invest in yourself. Your career is the engine of your wealth.', '15.jpg', '2022-04-12 12:26:51.000000', NULL, NULL, NULL, NULL),
(16, 'Paige', '1994-04-24', 'female', 'paige@yahoo.com', 'abcd1234', NULL, 'HELP University', 'Kuala Lumpur', NULL, 'Public Health Hero', NULL, '16.jpg', '2022-07-06 12:08:59.000000', NULL, NULL, NULL, NULL),
(17, 'Quinn', '1990-05-11', 'male', 'quinn@outlook.com', 'abcd1234', 'IT', NULL, 'Kajang', NULL, 'Software Innovator Award', 'Software is eating the world.', '17.jpg', '2022-05-09 08:02:45.000000', NULL, NULL, NULL, NULL),
(18, 'Rose', '2001-06-30', 'female', 'rose@gmail.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '18.jpg', '2022-04-26 09:17:45.000000', NULL, NULL, NULL, NULL),
(19, 'Sam', '1987-07-17', 'male', 'samy@iCloud.com', 'abcd1234', NULL, 'SEGi University', 'Kota Damansara', NULL, NULL, NULL, '19.jpg', '2021-09-09 11:19:54.000000', NULL, NULL, NULL, NULL),
(20, 'Tara', '1999-08-05', 'female', 'tara@gmail.com', 'abcd1234', 'Student', NULL, 'Kuala Lumpur', NULL, 'Clinical Research Award', 'Research is what I\'m doing when I don\'t know what I\'m doing.', '20.jpg', '2021-06-22 00:59:18.000000', NULL, NULL, NULL, NULL),
(21, 'Umar', '1998-09-16', 'male', 'umar@mail.com', 'abcd1234', 'IT', NULL, 'Puchong', NULL, 'AI Innovation Award', NULL, '21.jpg', '2021-10-22 06:10:30.000000', NULL, NULL, NULL, NULL),
(22, 'Vera', '1986-10-13', 'female', 'vera@outlook.com', 'abcd1234', 'Social', NULL, 'Putrajaya', NULL, 'Human Rights Award', NULL, '22.jpg', '2022-01-20 12:10:01.000000', NULL, NULL, NULL, NULL),
(23, 'Will', '1993-11-25', 'male', 'will@yahoo.com', 'abcd1234', 'Finance', 'Universiti Malaysia Terengganu', 'Kuala Terengganu', 'Malay', 'Risk Management Award', 'Risk comes from not knowing what you\'re doing.', '23.jpg', '2022-02-08 17:11:13.000000', NULL, NULL, NULL, NULL),
(24, 'Xena', '1992-12-07', 'female', 'xena@hotmail.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '24.jpg', '2022-05-11 11:12:53.000000', NULL, NULL, NULL, NULL),
(25, 'Yusuf', '2003-01-22', 'male', 'yusuf@outlook.com', 'abcd1234', 'Student', 'Asia Pacific University', 'Kuala Lumpur', 'Malay', 'Digital Transformation Award', 'Transformation is a process, and as life happens, there are tons of ups and downs.', '25.jpg', '2022-07-04 07:34:50.000000', NULL, NULL, NULL, NULL),
(26, 'Zara', '1990-02-19', 'female', 'zara@gmail.com', 'abcd1234', 'Social', NULL, NULL, NULL, 'Youth Leader Award', 'Youth is not a time of life; it is a state of mind.', '26.jpg', '2022-12-16 10:17:39.000000', NULL, NULL, NULL, NULL),
(27, 'Adam', '1989-03-05', 'male', 'adam@hotmail.com', 'abcd1234', 'Finance', 'Universiti Malaysia Perlis', NULL, 'Malay', 'Investment Innovation Award', NULL, '27.jpg', '2023-03-15 09:26:03.000000', NULL, NULL, NULL, NULL),
(28, 'Bella', '1996-04-14', 'female', 'bella@mail.com', 'abcd1234', 'Student', NULL, NULL, NULL, NULL, NULL, '28.jpg', '2023-05-25 23:42:34.000000', NULL, NULL, NULL, NULL),
(29, 'Chris', '1991-05-30', 'male', 'chris@gmail.com', 'abcd1234', 'IT', 'Asia Pacific University', 'Kuala Lumpur', 'Malay', 'Data Science Award', 'Data is the new oil.', '29.jpg', '2023-07-04 15:28:36.000000', NULL, NULL, NULL, NULL),
(30, 'Dana', '1995-06-18', 'female', 'dana@iCloud.com', 'abcd1234', 'Social', NULL, 'Melaka', NULL, NULL, NULL, '30.jpg', '2023-08-11 09:29:58.000000', NULL, NULL, NULL, NULL),
(31, 'Evan', '1997-07-23', 'male', 'evan@outlook.com', 'abcd1234', 'Finance', 'Universiti Malaysia Sabah', 'Kota Kinabalu', 'Malay', 'Young Investor Award', 'Invest in what you know.', '31.jpg', '2023-09-09 10:31:08.000000', NULL, NULL, NULL, NULL),
(32, 'Wilona', '2003-08-25', 'female', 'wilona@gmail.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '32.jpg', '2023-05-16 17:55:53.000000', NULL, NULL, NULL, NULL),
(33, 'Pei Pei', '2003-07-10', 'male', 'peipei@mail.com', 'abcd1234', 'Student', 'Universiti Malaysia Sarawak', 'Kuching', 'Iban', 'Health Innovator Award', 'Innovation is the calling card of the future.', '33.jpg', '2023-11-04 08:34:04.000000', NULL, NULL, NULL, NULL),
(34, 'Seow Tian', '2005-01-02', 'female', 'seowtian@gmail.com', 'abcd1234', 'Student', 'Universiti Teknologi MARA', 'Shah Alam', 'Malay', 'Women\'s Empowerment Award', 'Empowerment is about giving yourself the permission to not worry.', '34.jpg', '2024-02-06 09:35:49.000000', NULL, NULL, NULL, NULL),
(35, 'Jun Xuan', '2004-07-07', 'male', 'junxuan@gmail.com', 'abcd1234', 'Student', 'Asia Pacific University', 'Kuala Lumpur', 'English', 'Financial Literacy Award', 'Financial literacy is an essential skill.', '35.jpg', '2024-04-25 09:37:20.000000', NULL, NULL, NULL, NULL),
(36, 'Jadey', '2002-12-19', 'female', 'jadey@mail.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '36.jpg', '2024-04-16 13:38:42.000000', NULL, NULL, NULL, NULL),
(37, 'Arwin', '1994-01-30', 'male', 'arwin@outlook.com', 'abcd1234', 'IT', NULL, 'Cyberjaya', 'Malay', 'Cloud Computing Award', NULL, '37.jpg', '2024-06-30 08:39:47.000000', NULL, NULL, NULL, NULL),
(38, 'Chi', '1989-02-28', 'female', 'chi@yahoo.com', 'abcd1234', 'Social', 'Taylor University', 'Subang Jaya', 'English', 'Community Leadership Award', NULL, '38.jpg', '2024-05-01 06:40:53.000000', NULL, NULL, NULL, NULL),
(39, 'Max', '1992-03-15', 'male', 'max@gmail.com', 'abcd1234', 'Finance', 'Sunway University', 'Petaling Jaya', 'Cantonese', 'Corporate Finance Excellence', NULL, '26.jpg', '2023-08-24 10:16:41.000000', NULL, NULL, NULL, NULL),
(40, 'Angeline', '2004-01-11', 'female', 'xcloh1101@gmail.com', 'abcd1234', 'Student', 'Asia Pacific University', 'Kuala Lumpur', 'Cantonese ', 'Imagine World Cup by Microsoft, Champion', 'The secret of being human!🥹', '40.jpg', '2024-09-13 00:00:00.000000', 9, NULL, 10, 14),
(42, 'Jason', '2000-01-15', 'male', 'jason@gmail.com', 'abcd1234', NULL, NULL, NULL, NULL, NULL, NULL, '41.jpg', '2024-05-21 16:48:16.000000', NULL, NULL, NULL, NULL),
(62, 'xc', '2004-10-11', 'female', 'xcloh@gmail.com', 'abcd1234', 'null', 'null', 'null', 'null', 'null', 'null', 'pexels-clarango-3866555.jpg', '2024-08-19 14:31:59.374733', NULL, NULL, NULL, NULL),
(63, 'Adam', '2005-04-04', 'male', 'adam@gmail.com', 'abcd1234', 'Medicine', 'Universiti Malaysia Sarawak', 'Kuala Lumpur', 'Chinese', 'null', 'null', 'pexels-bubi-2709563.jpg', '2024-08-19 15:30:59.811343', NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `attendance - event` (`event_id`),
  ADD KEY `attendance - user` (`user_id`);

--
-- Indexes for table `business`
--
ALTER TABLE `business`
  ADD PRIMARY KEY (`business_id`);

--
-- Indexes for table `chat_participant`
--
ALTER TABLE `chat_participant`
  ADD PRIMARY KEY (`chat_id`),
  ADD KEY `chat - friend` (`friend_id`),
  ADD KEY `chat - friend2` (`friend_id_2`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `comment - post` (`post_id`),
  ADD KEY `comment - user` (`user_id`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `event - business` (`business_id`);

--
-- Indexes for table `friend`
--
ALTER TABLE `friend`
  ADD PRIMARY KEY (`friend_id`),
  ADD KEY `friend - user2` (`user_id_2`),
  ADD KEY `user_id` (`user_id`,`user_id_2`) USING BTREE;

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `message - chat` (`chat_id`),
  ADD KEY `message - user` (`user_id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `post - user` (`user_id`);

--
-- Indexes for table `preference`
--
ALTER TABLE `preference`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `request - user` (`user_id`),
  ADD KEY `request - user_2` (`user_id_2`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `review - user` (`user_id`),
  ADD KEY `review - post` (`post_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `user - event(IT)` (`event_it`),
  ADD KEY `user - event(Medicine)` (`event_medicine`),
  ADD KEY `user - event(Finance)` (`event_finance`),
  ADD KEY `user - event(Social)` (`event_social`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `attendance_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `business`
--
ALTER TABLE `business`
  MODIFY `business_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `chat_participant`
--
ALTER TABLE `chat_participant`
  MODIFY `chat_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `comment_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `event_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `friend`
--
ALTER TABLE `friend`
  MODIFY `friend_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `message_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `post_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `request`
--
ALTER TABLE `request`
  MODIFY `request_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `review_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance - event` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `attendance - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chat_participant`
--
ALTER TABLE `chat_participant`
  ADD CONSTRAINT `chat - friend` FOREIGN KEY (`friend_id`) REFERENCES `friend` (`friend_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `chat - friend2` FOREIGN KEY (`friend_id_2`) REFERENCES `friend` (`friend_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment - post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comment - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `event - business` FOREIGN KEY (`business_id`) REFERENCES `business` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `friend`
--
ALTER TABLE `friend`
  ADD CONSTRAINT `friend - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `friend - user2` FOREIGN KEY (`user_id_2`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message - chat` FOREIGN KEY (`chat_id`) REFERENCES `chat_participant` (`chat_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `message - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `preference`
--
ALTER TABLE `preference`
  ADD CONSTRAINT `preference - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `request - user_2` FOREIGN KEY (`user_id_2`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review - post` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `review - user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user - event(Finance)` FOREIGN KEY (`event_finance`) REFERENCES `event` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `user - event(IT)` FOREIGN KEY (`event_it`) REFERENCES `event` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `user - event(Medicine)` FOREIGN KEY (`event_medicine`) REFERENCES `event` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `user - event(Social)` FOREIGN KEY (`event_social`) REFERENCES `event` (`event_id`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
