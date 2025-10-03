import argparse
import sys

def parse_bed_record(file_handle):
    """
    Reads one line from the file handle and returns the tab-separated fields as a list,
    or None if EOF is reached.
    """
    line = file_handle.readline()
    if not line:
        return None  # End of file
    return line.strip().split('\t')

def main():
    parser = argparse.ArgumentParser(
        description="Searches for amplicons in a BED file and modifies them with a TRIM_LEFT tag.",
        formatter_class=argparse.RawTextHelpFormatter # Preserve newlines in help text
    )
    parser.add_argument(
        'lines_to_match_file',
        type=str,
        help="Path to the BED file containing amplicons to match (e.g., lines_to_match.bed)"
    )
    parser.add_argument(
        'full_bed_file',
        type=str,
        help="Path to the full BED file to be processed and modified (e.g., full.bed)"
    )
    parser.add_argument(
        '-o', '--output',
        type=str,
        required=True,
        help="Path to the output modified BED file (e.g., modified_full.bed)"
    )
    parser.add_argument(
        '-l', '--length',
        type=int,
        default=None,
        help="Fixed length value for TRIM_LEFT. If not specified, length is calculated from BED coordinates (end - start)."
    )

    args = parser.parse_args()

    # 1. Read AMPL_IDs from lines_to_match_file
    amplicon_ids_to_modify = set()
    try:
        with open(args.lines_to_match_file, 'r') as f_match:
            while True:
                record = parse_bed_record(f_match)
                if record is None:
                    break
                # AMPL_ID is the 4th line (index 3 in 0-indexed list)
                amplicon_ids_to_modify.add(record[3])
        print(f"Loaded {len(amplicon_ids_to_modify)} amplicon IDs to modify from '{args.lines_to_match_file}'.")
    except FileNotFoundError:
        print(f"Error: Matching amplicon file '{args.lines_to_match_file}' not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading matching amplicon file: {e}", file=sys.stderr)
        sys.exit(1)

    # 2. Process full_bed_file and write to output
    modified_count = 0
    try:
        with open(args.full_bed_file, 'r') as f_full, \
             open(args.output, 'w') as f_out:

            # Read and write the header line from the full_bed_file if it exists
            header_line = f_full.readline()
            if header_line: # Check if the file wasn't empty
                f_out.write(header_line)

            while True:
                record = parse_bed_record(f_full)
                if record is None:
                    break

                current_amplicon_id = record[3]

                if current_amplicon_id in amplicon_ids_to_modify:
                    # Calculate length: use command-line value if provided, otherwise calculate from coordinates
                    if args.length is not None:
                        length = args.length
                    else:
                        start = int(record[1])
                        end = int(record[2])
                        length = end - start

                    # Modify the 6th column (attributes)
                    # Ensure we handle cases where the 6th column might be empty
                    if len(record) > 5 and record[5]:
                        record[5] = f"{record[5]};TRIM_LEFT={length}"
                    elif len(record) > 5:
                        record[5] = f"TRIM_LEFT={length}"
                    else:
                        # If record has fewer than 6 columns, extend it
                        while len(record) < 5:
                            record.append('.')
                        record.append(f"TRIM_LEFT={length}")
                    modified_count += 1

                # Write the (potentially modified) record to the output file as tab-separated
                f_out.write('\t'.join(record) + '\n')

        print(f"Processing complete. Modified {modified_count} amplicons in '{args.full_bed_file}' and saved to '{args.output}'.")

    except FileNotFoundError:
        print(f"Error: Full BED file '{args.full_bed_file}' not found.", file=sys.stderr)
        sys.exit(1)
    except ValueError:
        print(f"Error: Non-integer coordinates found in '{args.full_bed_file}'. Ensure start/end coordinates are valid numbers.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error processing full BED file: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
