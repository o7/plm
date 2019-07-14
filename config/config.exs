use Mix.Config

config :n2o,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  port: 8043,
  proto: CHAT.Server,
  mqtt_services: ['erp', 'plm'],
  ws_services: ['chat'],
  upload: "./priv/static",
  protocols: [:n2o_heart, :n2o_nitro, CHAT.TXT, :n2o_ftp],
  routes: PLM.Routes

config :erp,
  boot: [:erp_boot, :plm_boot, :acc_boot, :pay_boot, :fin_boot]

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo]

config :form,
  registry: [
    LDAP.Forms.Credentials,
    LDAP.Forms.Access,
    BPE.Forms.Create,
    BPE.Rows.Trace,
    BPE.Rows.Process,
    PLM.Forms.Error,
    PLM.Rows.Payment,
    PLM.Rows.Investment,
    PLM.Rows.Product
  ]
