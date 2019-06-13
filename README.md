# self-signed
* make\_root.sh  
  创建根证书

* make\_signed.sh  
  使用根证书签发一个新证书
  
* show\_crt.sh  
  打印x509格式的证书信息  

* jks  
  使用Java工具keytool快速创建一套新证书
  + jks\_init\_ip.sh  
    初始化jks，并为证书绑定表态IP地址
  + jks\_req\_ip.sh  
    从jks创建CA签名申请（以CA作为根证书）
  + jks\_export.sh  
    从jks中导出证书部分（不支持私钥）
  + jks\_to\_p12.sh  
    将jks转换中p12格式（支持私钥）
  + make\_p12\_pem.sh  
    使用openssl将p12格式转换成pem格式
  + make\_p12\_key\_only.sh  
    使用openssl从p12格式中导出私钥部分
  + make\_p12\_crt\_only.sh  
    使用openssl从p12格式中导出公钥部分
  + make\_csr2crt.sh  
    使用openssl和CA证书为CSR签名，得到子证书

