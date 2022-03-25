'''python3 -m venv test
source test/bin/activate

pip3 install hdfs[Kerberos]

More info-https://pypi.org/project/hdfs/'''


from hdfs.ext.kerberos import KerberosClient
import requests
import subprocess as sp
import os

os.system("kinit -kt test.keytab test@EXAMPLE.COM")
session = requests.Session()
CERTS = "truststore.pem"
session.verify = CERTS
try:
    host=sp.getoutput("hdfs haadmin -getAllServiceState|grep active|awk '{print $1}'|awk -F':' '{print $1}'")
    print("Hostname is:" + host)
except:
    print ("Exception connecting namenodes")
port = '9871'
def main():
    client = KerberosClient('https://' + host + ':' + port,root='/',session=session)
    try:
        client.list("/")
    except:
        print("Unable to list file")
    def read():
        with client.read('/tmp/test/test.log') as reader:
            content=reader.read()
            print (content)
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    read()
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
    def delete():
        client.delete('/tmp/test/newtest')
    delete()
    print ("\033[1;32m List of Directory after deleteting newtest\n" + str(client.list("/tmp/test/")))
    print("################################")
    def makedirs():
        client.makedirs('/tmp/test/newtest')
    makedirs()
    print ("List of Directory after creating newtest\n" + str(client.list("/tmp/test/")))
if __name__ == "__main__":
 main()

