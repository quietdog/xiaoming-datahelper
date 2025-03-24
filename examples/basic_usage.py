from datahelper import CSVReader, DataProcessor


def main():
    # 读取CSV文件
    reader = CSVReader("examples/sample_data.csv")
    data = reader.read()

    # 数据处理
    processor = DataProcessor(data)
    stats = processor.calculate_stats("age")
    salary_stats = processor.calculate_stats("salary")

    print(f"年龄统计信息: {stats}")
    print(f"薪资统计信息: {salary_stats}")


if __name__ == "__main__":
    main()
