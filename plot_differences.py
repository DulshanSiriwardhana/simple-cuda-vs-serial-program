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
    plt.figure(figsize=(10, 5))
    plt.plot(diffs, label='Absolute Difference')
    plt.xlabel('Index')
    plt.ylabel('Difference')
    plt.title('Difference between CUDA and C Floating Point Results')
    plt.legend()
    plt.tight_layout()
    plt.savefig('differences_plot.png')
    plt.show()

if __name__ == "__main__":
    main() 