# Z++ Formal Specifications for RNDTBL

This directory contains formal specifications for the RNDTBL platform using Z++ notation, an object-oriented extension of the Z specification language.

## Overview

Z++ combines the mathematical rigor of Z with object-oriented concepts, making it ideal for specifying complex systems like RNDTBL.

## Specification Files

1. [CORE_TYPES.zpp](./CORE_TYPES.zpp) - Basic types and data structures
2. [GRAPH.zpp](./GRAPH.zpp) - Graph structure and operations
3. [USER.zpp](./USER.zpp) - User management and authentication
4. [SYNC.zpp](./SYNC.zpp) - Synchronization and conflict resolution
5. [NAMESPACE.zpp](./NAMESPACE.zpp) - Plan9 namespace model
6. [PERMISSIONS.zpp](./PERMISSIONS.zpp) - Access control and permissions

## Reading Guide

For those new to Z++:
- Square brackets `[...]` denote generic parameters
- `::=` defines types
- `|` separates alternatives in type definitions
- `∈` means "is a member of"
- `∀` means "for all"
- `∃` means "there exists"
- `⇒` means "implies"
- `∧` means "and"
- `∨` means "or"

## Related Documentation

- [ROADMAP.md](../../ROADMAP.md)
- [PLAN9_MODEL.md](../../PLAN9_MODEL.md)
