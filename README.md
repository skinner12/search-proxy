# SEARCH PROXY | [Articolo](https://www.rmazzu.com/articoli/usare-nmap-per-trovare-proxy-server/ "RMAZZU.com la casa del codice")



![Scan Proxy with NMAP](https://res.cloudinary.com/dhisshpng/image/upload/w_1200,c_scale/v1616534970/f3a7f5e9-eb5b-4a6f-8138-1147eee2abd1/10_3x_bwkifd.png)

A simple program to scan **NET** looking for *socks 4/5* proxy or *http* proxy.  

## Usage

```sh
cd search-proxy
./proxyscan.sh 1.2.3.1-254
```  

the argument *must* be **IP** or **CIDR Subnet Mask**, for example:`1.1.1.0/24`.  

### Parallel Workers
If you want to run  n parallel workers, add proxyscan to another script and run with `&`:  
  

```sh
cp scan.sh.example scan.sh
vim scan.sh
```  

And add `./proxyscan.sh 1.2.3.1-254 &` as in the example file.

## Output
If proxy is found, it will add to a text file with IP as prefix.
