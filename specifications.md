# Design Specifications — Asynchronous FIFO

## 1. Top-Level Parameters

| Parameter  | Value  | Description                                          |
|------------|--------|------------------------------------------------------|
| DATA_WIDTH | 8 bits | Width of wdata / rdata bus                           |
| ADDR_WIDTH | 4 bits | Address width — log2(FIFO_DEPTH)                     |
| FIFO_DEPTH | 16     | Number of storage locations = 2^ADDR_WIDTH           |
| PTR_WIDTH  | 5 bits | Pointer width = ADDR_WIDTH + 1 (extra MSB for full/empty distinction) |

---

## 2. Clock Domains

| Clock | Frequency | Period | Domain     |
|-------|-----------|--------|------------|
| wclk  | 100 MHz   | 10 ns  | Write side |
| rclk  | 50 MHz    | 20 ns  | Read side  |

> **Frequency Ratio:** fW : fR = 2 : 1 — write side is twice as fast as read side.

---

## 3. Reset Specification

| Signal | Polarity   | Domain | Description                        |
|--------|------------|--------|------------------------------------|
| w_rst  | Active LOW | wclk   | Resets wptr, waddr, wfull          |
| r_rst  | Active LOW | rclk   | Resets rptr, raddr, rempty         |

Reset is asserted asynchronously and released synchronously, held for minimum 2 clock cycles in respective domain.

---

## 4. Port List

| Signal | Direction | Width | Domain | Description            |
|--------|-----------|-------|--------|------------------------|
| wclk   | Input     | 1     | Write  | Write clock            |
| w_rst  | Input     | 1     | Write  | Active-low write reset |
| winc   | Input     | 1     | Write  | Write enable request   |
| wdata  | Input     | 8     | Write  | Write data bus         |
| wfull  | Output    | 1     | Write  | FIFO full flag         |
| rclk   | Input     | 1     | Read   | Read clock             |
| r_rst  | Input     | 1     | Read   | Active-low read reset  |
| rinc   | Input     | 1     | Read   | Read enable request    |
| rdata  | Output    | 8     | Read   | Read data bus          |
| rempty | Output    | 1     | Read   | FIFO empty flag        |

---

## 5. Derived Parameters

```
ADDR_WIDTH  = log2(FIFO_DEPTH) = log2(16) = 4 bits
PTR_WIDTH   = ADDR_WIDTH + 1   = 5 bits
DATA_WIDTH  = 8 bits  (configurable)
```

---

## 6. Full / Empty Flag Conditions

EMPTY (checked in rclk domain):

```
rempty = 1   when   rptr (Gray) == wptr_synch (synchronized wptr)
```

FULL (checked in wclk domain):

```
wfull = 1   when   wptr[4:3] == ~rptr_synch[4:3]   (top 2 bits inverted)
              AND   wptr[2:0] ==  rptr_synch[2:0]   (lower 3 bits equal)
```

---

## 7. Simulation Configuration

| Parameter          | Value                                                                   |
|--------------------|-------------------------------------------------------------------------|
| Write clock period | 10 ns (100 MHz)                                                         |
| Read clock period  | 20 ns (50 MHz)                                                          |
| Reset duration     | ≥ 2 cycles in each domain                                               |
| Test scenarios     | Reset, single write/read, burst write, FIFO full, FIFO empty, simultaneous read/write |