# The board — standing URL

**https://claude.ai/code/artifact/e3f79293-d3ca-41f4-b964-cb442be61901**

Every /mission render republishes to this URL (Decision 7.1) — bookmark it; it is always
the latest board. Machine-maintained: /mission reads this file and passes the URL to the
Artifact tool's `url` parameter. If this file is ever lost, the next /mission run creates
a fresh artifact and rewrites it here.

**Freshness:** re-rendered hourly by the "Mission Control board refresh" Routine, and on
demand — type `/mission` in any Claude chat. The page itself is a point-in-time render;
the timestamp under the wordmark says when.
