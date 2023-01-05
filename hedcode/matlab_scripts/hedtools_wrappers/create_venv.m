function success = create_venv(target_directory)
    % Returns 0 if it thinks it succeeded, non zero otherwise.
    if ~contains(target_directory, "venv")
        target_directory = fullfile(target_directory, "venv");
    end
    % this seems to always return 0, so it cannot be used for error checking.
    result = system("python3 -m venv " + target_directory);
    if result ~= 0
        print("Something went wrong with creating the virtual environment.  Probably a permissions issue on the target directory.")
        success = 1;
        return
    end
    % Set the python environment to use this virtual environment
    pyenv("Version", fullfile(target_directory, "/bin/python"));
    pip_path = fullfile(target_directory, "/bin/pip");
    % install hedtools to this virtual environment
    result_hed_install = system(pip_path + " install hedtools");
    if result_hed_install ~= 0
        print("Something went wrong with installing hedtools to virtual environment.  Probably a permissions issue on the target directory.")
        success = 1;
        return
    end
    success = 0;
end
