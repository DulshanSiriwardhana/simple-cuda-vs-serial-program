import matplotlib.pyplot as plt

def read_output(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    values = [float(line.strip().split()[1]) for line in lines]
    return values

def main():
    cuda_vals = read_output('cuda_output.txt')
    c_vals = read_output('c_output.txt')
    diffs = [abs(a - b) for a, b in zip(cuda_vals, c_vals)]
    with open('differences.txt', 'w') as df:
        for i, (a, b, d) in enumerate(zip(cuda_vals, c_vals, diffs)):
            print(f"Index {i}: CUDA={a:.12f}, C={b:.12f}, Diff={d:.12e}")
            df.write(f"{i} {a:.12f} {b:.12f} {d:.12e}\n")
    print(f"Max difference: {max(diffs):.12e}")
    print(f"Total difference: {sum(diffs):.12e}")

if __name__ == "__main__":
    main() 