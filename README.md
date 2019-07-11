PLM: Product Lifecycle Management
=================================

Product Lifecycle Management (PLM) is an application for
managing long term projects and products, tracking its
payments and investments.


Features
--------

* Usage Example of N2O, KVX, BPE, NITRO
* RocksDB support out of the box
* Elixir language

Prerequisites
-------------

* Erlang/OTP 21.0 (by apt or brew)
* Elixir 1.9.0 (by exenv)
* build-essential, cmake (needed for rocksdb)

Run
---

Before running, [fullchain.pem](./priv/ssl/fullchain.pem) certificate has to be added into a system.

```
$ mix deps.get
$ mix compile
$ mix release
$ _build/dev/rel/plm/bin/plm daemon
$ _build/dev/rel/plm/bin/plm remote
```

Then open `https://localhost:8043/app/index.html`

Notes
-----

* [2019-03-07 FORMS 4.3](https://tonpa.guru/stream/2019/2019-03-07%20Новая%20версия%20FORMS.htm)
* [2019-04-11 BPE 4.4](https://tonpa.guru/stream/2019/2019-04-11%20Новая%20версия%20BPE.htm)
* [2019-04-13 KVX 6.4](https://tonpa.guru/stream/2019/2019-04-13%20Новая%20версия%20KVX.htm)
* [2019-06-10 N2O 6.6](https://tonpa.guru/stream/2019/2019-06-10%20N2O%20MIX.htm)
* [2019-06-19 BPE 4.6](https://tonpa.guru/stream/2019/2019-06-19%20BPE%20MIX.htm)
* [2019-06-21 PLM 0.6](https://tonpa.guru/stream/2019/2019-06-21%20Новые%20версии%20BUD%20и%20BANK.htm)
* [2019-06-30 SYNRC ENTERPRIZING 0.7](https://tonpa.guru/stream/2019/2019-06-30%20DEPOT.htm)
* [2019-07-08 ERP BOOT 0.7](https://tonpa.guru/stream/2019/2019-07-08%20ERP%20BOOT.htm)
* [2019-07-08 KVS ADM 0.7](https://tonpa.guru/stream/2019/2019-07-08%20KVS%20ADM.htm)
* [2019-07-09 BPE ADM 0.7](https://tonpa.guru/stream/2019/2019-07-09%20BPE%20ADM.htm)

Credits
-------

* Maxim Sokhatsky [5HT](https://github.com/5HT)

OM A HUM
