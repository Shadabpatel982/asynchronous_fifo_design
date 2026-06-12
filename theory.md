# Async FIFO — Theory Documentation

## 1. What is a FIFO?

FIFO stands for First In First Out. It is a memory buffer with two ports:

- Write port — data enters here
- Read port — data exits here, in the same order it was written

---

## 2. What Makes it Asynchronous?

A synchronous FIFO uses one clock for both read and write sides.

An asynchronous FIFO uses two completely independent clocks:

```
wclk (100 MHz) → WRITE side
rclk (50 MHz)  → READ side
```

The two clocks have no fixed phase or frequency relationship.

---

## 3. Why Do We Need Async FIFO?

In real systems, different blocks run at different clock frequencies:

| Use Case          | Write Side         | Read Side           |
|-------------------|--------------------|---------------------|
| CPU → Ethernet    | CPU core clock     | PHY clock (125 MHz) |
| ADC → DSP         | ADC sample clock   | DSP clock           |
| FPGA → FPGA       | FPGA1 clock        | FPGA2 clock         |
| UART → System bus | Baud-derived clock | System clock        |

Direct connection between these domains causes metastability.

---

## 4. Clock Domain Crossing and Metastability

When a signal generated in clock domain A is sampled in clock domain B, the signal may be changing at the exact moment of the clock edge. This violates the setup and hold time requirements of the flip-flop.

Result: the flip-flop output goes to an undefined voltage — neither 0 nor 1. This is metastability.

Metastability is dangerous because:
- It can propagate to other flip-flops
- It causes unpredictable, non-reproducible behavior
- It can cause system failures

---

## 5. Gray Code

A Gray code is a binary numbering system where only 1 bit changes between consecutive values.

| Decimal | Binary | Gray Code |
|---------|--------|-----------|
|    0    |  0000  |   0000    |
|    1    |  0001  |   0001    |
|    2    |  0010  |   0011    |
|    3    |  0011  |   0010    |
|    4    |  0100  |   0110    |

Why does this matter for FIFO pointers?

If a multi-bit binary counter is sampled at the wrong time during a clock crossing, multiple bits changing simultaneously can result in an incorrect intermediate value. With Gray code, even if the synchronizer samples at the wrong moment, it captures either the old or new value — both are valid.

Conversion formula:

```
Gray[i] = Binary[i] XOR Binary[i+1]
```

---

## 6. 2FF Synchronizer

The standard circuit to safely cross a signal from one clock domain to another:

```
Source domain          Destination domain
                            FF1        FF2
  signal  ─────────►  [───────]──►[───────]──► safe output
                        (dclk)      (dclk)
```

- FF1 may go metastable when it samples the input
- It has a full clock cycle to resolve before FF2 samples it
- FF2 output is guaranteed clean
- Adds exactly 2 clock cycles of latency

---

## 7. Full and Empty Flag Generation

EMPTY (generated in rclk domain):

```
rempty = 1  when  rptr == wptr_synch
```

Read pointer equals the synchronized write pointer — nothing left to read.

FULL (generated in wclk domain):

```
wfull = 1  when  wptr[MSBs] inverted vs rptr_synch[MSBs]
                 AND lower bits equal
```

Write pointer has lapped the read pointer by one full revolution.

The key difference: EMPTY uses all-bits-equal (same wrap count), FULL uses inverted MSBs (different wrap count by exactly 1).

---

## Reference

Clifford E. Cummings — *Simulation and Synthesis Techniques for Asynchronous FIFO Design*, SNUG 2002  
<https://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf>