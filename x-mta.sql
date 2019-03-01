-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 01 Mar 2019, 21:12
-- Wersja serwera: 10.1.34-MariaDB
-- Wersja PHP: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `X-MTA`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mta_sessions`
--

CREATE TABLE `mta_sessions` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `serial` text COLLATE utf8_polish_ci,
  `ip` text COLLATE utf8_polish_ci,
  `joinDate` timestamp NULL DEFAULT NULL,
  `quitDate` timestamp NULL DEFAULT NULL,
  `quitType` text COLLATE utf8_polish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mta_users`
--

CREATE TABLE `mta_users` (
  `id` int(11) NOT NULL,
  `login` text COLLATE utf8_polish_ci,
  `password` text COLLATE utf8_polish_ci,
  `email` text COLLATE utf8_polish_ci,
  `registerSerial` text COLLATE utf8_polish_ci,
  `registerIP` text COLLATE utf8_polish_ci,
  `lastSeen` timestamp NULL DEFAULT NULL,
  `lastQuit` timestamp NULL DEFAULT NULL,
  `globalData` text COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mta_vehicles`
--

CREATE TABLE `mta_vehicles` (
  `id` int(11) NOT NULL,
  `model` int(11) DEFAULT NULL,
  `position` tinytext COLLATE utf8_polish_ci,
  `health` int(11) DEFAULT '1000',
  `isSpawn` tinyint(1) NOT NULL DEFAULT '1',
  `isLocked` tinyint(1) DEFAULT '1',
  `handbrake` tinyint(1) NOT NULL DEFAULT '0',
  `wheelStates` text COLLATE utf8_polish_ci,
  `panelState` text COLLATE utf8_polish_ci,
  `doorState` text COLLATE utf8_polish_ci,
  `lightState` text COLLATE utf8_polish_ci,
  `globalData` mediumtext COLLATE utf8_polish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `mta_vehicles`
--

INSERT INTO `mta_vehicles` (`id`, `model`, `position`, `health`, `isSpawn`, `isLocked`, `handbrake`, `wheelStates`, `panelState`, `doorState`, `lightState`, `globalData`) VALUES
(1, 410, '1780.1953125,-2588.8251953125,13.208242416382,359.46173095703,0,77.36572265625', 850, 1, 1, 1, '[ [ 0, 0, 0, 0 ] ]', '[ [ 2, 0, 0, 0, 0, 2, 1 ] ]', '[ [ 0, 2, 0, 0, 0, 0 ] ]', '[ [ 0, 2, 0, 0 ] ]', '[ { \"color\": [ 123, 255, 17, 0, 47, 255, 0, 0, 0, 0, 0, 0 ] } ]'),
(2, 411, '1791.4658203125,-2590.384765625,13.266774177551,0,357.31384277344,59.4140625', 1000, 1, 0, 0, '[ [ 1, 1, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ { \"color\": [ 14, 221, 224, 0, 47, 255, 0, 0, 0, 0, 0, 0 ] } ]');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `mta_sessions`
--
ALTER TABLE `mta_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `mta_users`
--
ALTER TABLE `mta_users`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `mta_vehicles`
--
ALTER TABLE `mta_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `mta_sessions`
--
ALTER TABLE `mta_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mta_users`
--
ALTER TABLE `mta_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mta_vehicles`
--
ALTER TABLE `mta_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
