vault delete myca_ops/roles/server
vault write myca_ops/roles/server \
    max_ttl="8760h" \
    key_bits=2048 \
    allow_any_name=true \
    server_flag=true \
    client_flag=true \
    ou="CloudRA Team" organization="HPE"
