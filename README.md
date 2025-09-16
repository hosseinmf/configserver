# ConfigServer Installer

اسکریپت **ConfigServer Installer** ابزاری ساده برای نصب یا حذف محصولات رایگان ConfigServer  
شامل **cmc، cmm، cmq، cse و csf** بر روی کنترل‌پنل‌های مختلف است.

کنترل‌پنل‌های پشتیبانی‌شده:
- cPanel
- CWP
- CyberPanel
- DirectAdmin
- Interworx
- Generic
- Vesta

---

## 🚀 اجرای سریع (یک خطی)

برای اجرای مستقیم اسکریپت:

```bash
bash <(curl -s https://raw.githubusercontent.com/hosseinmf/configserver/main/installer.sh)
```

این دستور:
1. از شما نام کنترل‌پنل را می‌پرسد.
2. محصول مورد نظر (cmc, cmm, cmq, cse, csf) را می‌پرسد.
3. امکان **install** یا **uninstall** را می‌دهد.
4. آخرین نسخه را از گیت‌هاب رسمی دانلود و اجرا می‌کند.

---

## 🛠 پیش‌نیازها
- سیستم عامل لینوکس
- ابزارهای `curl` و `tar`
- دسترسی کاربر `sudo` یا root

---

## 📂 ساختار مخزن
```
configserver/
├─ installer.sh    # اسکریپت اصلی نصب/حذف
└─ README.md       # این فایل
```

---

## ⚖️ لایسنس
این پروژه تحت مجوز **GPL v3** منتشر شده است.  
شما می‌توانید از این اسکریپت استفاده، تغییر یا بازنشر کنید، مشروط بر آنکه متن مجوز را رعایت کنید.

---

---

# ConfigServer Installer (English)

The **ConfigServer Installer** is a simple script to **install or uninstall** free ConfigServer products  
(**cmc, cmm, cmq, cse, csf**) on various hosting control panels.

Supported control panels:
- cPanel
- CWP
- CyberPanel
- DirectAdmin
- Interworx
- Generic
- Vesta

---

## 🚀 Quick One-Liner Run


```bash
bash <(curl -s https://raw.githubusercontent.com/hosseinmf/configserver/main/installer.sh)
```

This command will:
1. Ask for the control panel.
2. Ask which product to manage (cmc, cmm, cmq, cse, csf).
3. Let you choose **install** or **uninstall**.
4. Download and execute the latest release directly from GitHub.

---

## 🛠 Requirements
- Linux operating system
- `curl` and `tar` installed
- `sudo` or root privileges

---

## 📂 Repository Structure
```
configserver/
├─ installer.sh    # Main install/uninstall script
└─ README.md       # This file
```

---

## ⚖️ License
Released under **GPL v3** license.  
You are free to use, modify, and redistribute this script as long as the license terms are followed.
