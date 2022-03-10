import os
from hed.errors.error_reporter import get_printable_issue_string
from hed.tools.bids.bids_dataset import BidsDataset


if __name__ == '__main__':
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        '../../../datasets/eeg_ds003654s_hed_library')
    bids = BidsDataset(path)
    # Validate and include warnings
    print("Validating and include warnings...")
    issue_list1 = bids.validate(check_for_warnings=True)
    if issue_list1:
        issue_str = get_printable_issue_string(issue_list1, "HED_library issues with warnings")
        print(f"Issues (including warnings):\n{issue_str}")
    else:
        print("...No issues even when warnings included")

    # Validate and don't include warnings
    print("Validating and don't include warnings...")
    issue_list2 = bids.validate(check_for_warnings=False)
    if issue_list2:
        issue_str = get_printable_issue_string(issue_list2, "HED_library issues with no warnings")
        print(f"Issues (including warnings):\n{issue_str}")
    else:
        print("...No issues when warnings not included")
