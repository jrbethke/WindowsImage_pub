# Imaging Scripts for Custom Windows Imaging

Hello fellow traveler!

This series of scripts is designed to custom image Windows computers. The domain addition script is currently being developed, but non-domain computers are ready to go.

**TLDR;** Run the application as an administrator and follow the prompts. Make sure there is an `installs` and `items` folder if there is anything you want to add specifically.

---

### Things to change for it to function:

1. **Place items you want to install on the computer into a folder named "installs":**
    - Place the installer(s) into the `installs` folder. The script will automatically detect and install any software packages found in this folder.
    - **Preferred Method:** It is highly recommended to include the **Google Chrome installer** in the `installs` folder. This ensures that Chrome is installed during the imaging process, as it is often required for many environments.

2. **Prepare the Computer Name:**
    - Have a name ready for the computer. If you're replacing an old computer, ensure that the previous device has been removed from N-able before running the script.

3. **Running the Script:**
    - The script must be **run as an administrator** for it to work properly. It will automatically elevate the shell to admin when needed.
    - To run the script, navigate to the directory and run the `ImagingApplication.exe` application. This will call the other scripts and automate the process.

4. **User Input:**
    - There are a couple of user entry fields to keep in mind, such as naming the device and confirming whether you want to download Windows updates.
    - After entering these details, the script will handle the rest automatically.

5. **Windows Updates:**
    - The script will automatically install available Windows updates without prompting for a reboot. It uses the `PSWindowsUpdate` module to search for and install updates.

6. **Silent Software Installation:**
    - All software packages placed in the `installs` folder will be detected and installed silently, using the `/qn` argument for silent installation. The script waits until each installation is completed before moving on to the next.

---

### Additional Notes:

- **Administrator Privileges:** Ensure the script is run as an administrator for proper installation of updates, software, and configuration changes.
- **Customization:** You can customize the software to be installed by placing the installers in the `installs` folder. The script will automatically find and run them in silent mode.
- **Updates:** The script checks for available updates from Microsoft and installs them without requiring a reboot, ensuring your system is fully updated.
- **Automatic Process:** After the initial user input (such as the computer name and confirmation of updates), the process is mostly automatic.

---

Thanks for using the imaging scripts! If you have any issues or questions, feel free to reach out!
