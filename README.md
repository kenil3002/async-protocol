# Custom Asynchronous 4-Bit Bidirectional Protocol

## 1. Problem Statement

Modern digital systems often require communication between a master and a slave without relying on a shared clock. Standard protocols may be over-featured or unsuitable for simple, low-pin-count designs.

The objective of this project is to **design and implement a lightweight asynchronous custom communication protocol** using only **6 signal lines**, capable of performing both **read and write operations** over a **bidirectional data bus**, operating at an effective baud rate of **9600 bps**.

The protocol must:
- Work **without a shared clock** between master and slave
- Support **bidirectional data transfer**
- Clearly indicate **data direction and validity**
- Be simple enough to implement using an FSM

---

## 2. What This Project Does

This project implements a **master-initiated asynchronous protocol** using:
- A **Finite State Machine (FSM)** on the master side
- A **request-based handshake mechanism**
- A **4-bit bidirectional data bus**

The protocol allows:
- **Write operation**: Master sends data to slave
- **Read operation**: Slave sends data to master

The system uses a **baud-rate-based timing window** (9600 bps) to ensure reliable data sampling in the absence of a clock.

---

## 3. Signal Description

| Signal Name | Width | Direction | Description |
|-----------|------|----------|------------|
| `req` | 1 | Master → Slave | Request signal indicating valid data phase |
| `rw` | 1 | Master → Slave | Direction control (1 = Write, 0 = Read) |
| `data` | 4 | Bidirectional | 4-bit data bus |
| `clk` | 1 | Local (Master) | Internal reference clock for baud timing |
| `rst_n` | 1 | Input (local) | Active-low reset |

> Note: `clk` is **not shared** with the slave and is used only to generate baud-rate delays.

---

## 4. Protocol Overview

This is a **2-phase asynchronous protocol** based on the `req` signal.

### Idle Condition
- `req = 0`
- `data` bus is released (high-Z)
- No transaction in progress

---

## 5. Write Operation (Master → Slave)

### Sequence of Events

1. Master sets `rw = 1` to indicate write operation
2. Master drives valid data on `data[3:0]`
3. Master asserts `req = 1`
4. Slave detects `req` high and samples data
5. Master holds signals for one baud interval
6. Master deasserts `req = 0`
7. Data bus is released and protocol returns to idle

### Write Timing Concept


---

## 6. Read Operation (Slave → Master)

### Sequence of Events

1. Master sets `rw = 0` to indicate read operation
2. Master asserts `req = 1`
3. Slave detects `req` and drives data on `data[3:0]`
4. Master samples data during the data phase
5. Master holds `req` for one baud interval
6. Master deasserts `req = 0`
7. Slave releases the data bus

### Read Timing Concept

