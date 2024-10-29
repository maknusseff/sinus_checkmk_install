import lsb_release

print("Sinus Checkmk Installation")

uversion = lsb_release.get_lsb_information()["CODENAME"]

print(f"You are using Ubuntu {lsb_release.get_lsb_information()["RELEASE"]} {lsb_release.get_lsb_information()["CODENAME"]}")