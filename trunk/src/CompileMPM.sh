gfortran -O3 -o mpm mpm.f sourcewl.f addsource.f mpm_io.f\
	vel4.f tau4.f clayeng.f vel2.f tau2.f\
	abs_cerjan.f abs_fresnel_wide.f abs_fresnel_narrow.f\
	setmpmgrid.f getmodel.f savestate.f restorestate.f\
	checkarray.f mpm_filehandles.f read_mpmpar.f read_wavepos.f\
        read_source.f setup_recpos.f transp.f transpout.f gethzmodel.f\
        mpm_pad_model.f add_freesurface.f 
