def get_input(prompt):
    """
   Function Get input from the user maintaining the python compatibility 
with earlier and newer versions.
   """
    if sys.hexversion > 0x03000000:
        return input(prompt)
    else:
        return raw_input(prompt)
