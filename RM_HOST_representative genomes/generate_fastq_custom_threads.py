import sys
import concurrent.futures
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq

def generate_kmers(seq, k_size):
    """生成指定长度k的k-mers"""
    for i in range(len(seq) - k_size + 1):
        yield seq[i:i + k_size]

def process_record(record, k_size):
    """处理单个记录，返回FASTQ格式的k-mers"""
    record_list = []
    record_counter = 1
    for kmer in generate_kmers(str(record.seq), k_size):
        # 创建一个SeqRecord对象
        qual = 'I' * k_size  # Phred quality score of 40
        new_record = SeqRecord(Seq(kmer), 
                               id=f"seq{record_counter}",
                               description="",
                               letter_annotations={"phred_quality": [40]*k_size})
        record_list.append(new_record)
        record_counter += 1
    return record_list

def write_fastq_kmers(input_file, output_file, k_size=100, num_workers=4):
    """从FASTA文件生成k-mer并以FASTQ格式写入输出文件，使用多线程加速处理"""
    with open(output_file, 'w') as out:
        with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
            futures = []
            for record in SeqIO.parse(input_file, "fasta"):
                futures.append(executor.submit(process_record, record, k_size))
            for future in concurrent.futures.as_completed(futures):
                SeqIO.write(future.result(), out, "fastq")

def main():
    if len(sys.argv) < 3:
        print("Usage: python generate_fastq_custom_threads.py <input.fasta> <output.fastq> [num_threads]")
        sys.exit(1)

    input_file, output_file = sys.argv[1], sys.argv[2]
    num_workers = int(sys.argv[3]) if len(sys.argv) > 3 else 4  # 默认线程数为4
    write_fastq_kmers(input_file, output_file, num_workers=num_workers)

if __name__ == "__main__":
    main()
