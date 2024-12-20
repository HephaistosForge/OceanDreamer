import matplotlib.pyplot as plt
import pandas as pd

data = {"Combination": [], "DPS": []}
for line in open("dps.txt"):
    name, dps = line.strip().split(":")
    # if "+" in name:
    #     continue
    data["Combination"].append(name.removesuffix(" dps"))
    data["DPS"].append(float(dps))


s = sorted(zip(data["DPS"], data["Combination"]))
# print(s)
# s = {tuple(sorted(a[1].split("+"))): a[0] for a in s}
s2 = []
for dps, comb in s:
    if comb.split("+") == sorted(comb.split("+")):
        s2.append((dps, comb))
a = list(zip(*s2))
data = {"Combination": a[1], "DPS": a[0]}

df = pd.DataFrame(data)

def get_color(name):
    name = name.removesuffix(" dps")
    if "Base" in name:
        return "black"
    if "+" in name:
        match len(set(name.split("+"))):
            case 1: return "red"
            case 2: return "green"
    return "blue"

color = [get_color(a) for a in a[1]]

names = [name + (" " * (i % 2) * 50) for i, name in enumerate(df["Combination"])]


plt.figure(figsize=(12, 6))
plt.barh(names, df["DPS"], color=color)
plt.xlabel("DPS")
plt.ylabel("Combination")
plt.title("DPS for Weapon Combinations")
plt.tight_layout()
plt.show()
