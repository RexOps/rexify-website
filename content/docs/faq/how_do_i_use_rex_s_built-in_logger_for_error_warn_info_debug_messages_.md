---
title: How do I use Rex's built-in logger for ERROR/WARN/INFO/DEBUG messages?
---

    Rex::Logger::info("some message");           # for INFO  (green)
    Rex::Logger::info("some message", "warn");   # for WARN  (yellow)
    Rex::Logger::info("some message", "error");  # for ERROR (red)
