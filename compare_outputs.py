def read_output(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    values = [float(line.strip().split()[1]) for line in lines]
    return values

def main():
    cuda_vals = read_output('cuda_output.txt')
    c_vals = read_output('c_output.txt')
    if len(cuda_vals) != len(c_vals):
        print(f"Length mismatch: CUDA={len(cuda_vals)}, C={len(c_vals)}")
        return
    max_diff = 0.0
    total_diff = 0.0
    for i, (a, b) in enumerate(zip(cuda_vals, c_vals)):
        diff = abs(a - b)
        if diff > max_diff:
            max_diff = diff
        total_diff += diff
        if diff > 1e-6:
            print(f"Index {i}: CUDA={a:.8f}, C={b:.8f}, Diff={diff:.8e}")
    print(f"Max difference: {max_diff:.8e}")
    print(f"Total difference: {total_diff:.8e}")

if __name__ == "__main__":
    main() 