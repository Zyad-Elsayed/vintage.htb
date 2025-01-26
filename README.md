### **Vintage Machine Attack Script**
This script automates the attack process for the **Vintage** machine from **Hack The Box**. It leverages tools like `bloodyAD`, `Impacket`, and Kerberos to perform a series of Active Directory enumeration, exploitation, and privilege escalation steps. The script is designed to streamline the process, making it easier to execute complex attacks with minimal manual intervention.

---

### **Features**
- **Automated Steps**: Executes a sequence of attacks, including:
  - Retrieving managed passwords for Group Managed Service Accounts (GMSA).
  - Adding users to privileged groups.
  - Modifying user account controls (UAC) and service principal names (SPN).
  - Dumping secrets using `Impacket-secretsdump`.
- **Error Handling**: Stops execution if any step fails, ensuring reliability.
- **Colorized Output**: Provides clear, color-coded feedback for each step.
- **Kerberos Integration**: Handles ticket granting tickets (TGT) and service tickets seamlessly.

---

### **Tools Used**
- **[bloodyAD](https://github.com/CravateRouge/bloodyAD)**: A Python-based tool for Active Directory enumeration and exploitation.
- **[Impacket](https://github.com/fortra/impacket)**: A collection of Python classes for working with network protocols.
- **Kerberos**: Used for authentication and ticket management.

---

### **Usage**
1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/vintage-attack-script.git](https://github.com/Zyad-Elsayed/vintage.htb.git)
   cd vintage.htb
   ```
2. Make the script executable:
   ```bash
   chmod +x script.sh
   ```
3. Run the script:
   ```bash
   ./script.sh
   ```

---

### **Steps Automates**
1. **Retrieve Managed Password for GMSA01$**.
2. **Obtain TGT for GMSA01$**.
3. **Add P.Rosa to the SERVICEMANAGERS Group**.
4. **Obtain TGT for P.Rosa**.
5. **Enable SVC_SQL Account by Removing ACCOUNTDISABLE Flag**.
6. **Set Service Principal Name (SPN) for SVC_SQL**.
7. **Obtain TGT for c.neri_adm**.
8. **Add SVC_SQL to the DELEGATEDADMINS Group**.
9. **Obtain TGT for svc_sql**.
10. **Impersonate L.BIANCHI_ADM and Obtain Service Ticket**.
11. **Dump Secrets Using Impacket-secretsdump**.

![image](https://github.com/user-attachments/assets/a032a683-c66f-4c0b-8525-30869b890e14)
![Pasted image 20250124061310](https://github.com/user-attachments/assets/6b644651-d514-412c-9c64-8f191203c275)
![image](https://github.com/user-attachments/assets/bab4249a-f91f-4a83-af20-c286f0e20ae9)
![Pasted image 20250124061407](https://github.com/user-attachments/assets/d8d302ac-f545-42c3-8bfb-1e954b60e993)
---

### **Requirements**
- Python 3.x
- `bloodyAD` installed and configured.
- `Impacket` installed.
- Kerberos tools (`getTGT.py`, `getST.py`) available.

---

### **Disclaimer**
This script is intended for educational purposes only. Use it only on systems you own or have explicit permission to test. The author is not responsible for any misuse or damage caused by this script.

---

Feel free to customize this description further to match your style or add additional details! Let me know if you need help with anything else. 🚀

