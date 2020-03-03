Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B975217718C
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 09:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCCIuo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 03:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgCCIun (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 3 Mar 2020 03:50:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FA920873;
        Tue,  3 Mar 2020 08:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583225442;
        bh=eR6LH6mxRiiMpd/1mg6HONvlCCBV3PmOyYycLqHqkdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEDuts2CyWKxUkuRazmkCwT4hZjsAxqrHnv14Uf/LNboVoyo0q8uTK5wcmrqOiCfz
         d64lQUTg3g5FM9OQUp2chBDAGhbLXbHoANW6G9t4HWgZx/OQxWiIuJky8Iqwupvt4Q
         ex517U3FK6IIxONywHvdH+C/N1tSRCy/KDMqPNys=
Date:   Tue, 3 Mar 2020 09:50:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/6] powerpc: kvm: no need to check return value of
 debugfs_create functions
Message-ID: <20200303085039.GA1323622@kroah.com>
References: <20200209105901.1620958-1-gregkh@linuxfoundation.org>
 <20200209105901.1620958-2-gregkh@linuxfoundation.org>
 <87imjlswxc.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imjlswxc.fsf@mpe.ellerman.id.au>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 03, 2020 at 06:46:23PM +1100, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> 
> Except it does need to do something different, if the file was created
> it needs to be removed in the remove path.
> 
> > diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
> > index bfe4f106cffc..8e4791c6f2af 100644
> > --- a/arch/powerpc/kvm/timing.c
> > +++ b/arch/powerpc/kvm/timing.c
> > @@ -207,19 +207,12 @@ static const struct file_operations kvmppc_exit_timing_fops = {
> >  void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
> >  {
> >  	static char dbg_fname[50];
> > -	struct dentry *debugfs_file;
> >  
> >  	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
> >  		 current->pid, id);
> > -	debugfs_file = debugfs_create_file(dbg_fname, 0666,
> > -					kvm_debugfs_dir, vcpu,
> > -					&kvmppc_exit_timing_fops);
> > -
> > -	if (!debugfs_file) {
> > -		printk(KERN_ERR"%s: error creating debugfs file %s\n",
> > -			__func__, dbg_fname);
> > -		return;
> > -	}
> > +	debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
> > +			    &kvmppc_exit_timing_fops);
> > +
> >  
> >  	vcpu->arch.debugfs_exit_timing = debugfs_file;

Ugh, you are right, how did I miss that?  How is 0-day missing this?
It's been in my tree for a long time, odd.

> >  }
> 
> This doesn't build:
> 
>     arch/powerpc/kvm/timing.c:217:35: error: 'debugfs_file' undeclared (first use in this function); did you mean 'debugfs_file_put'?
> 
> We can't just drop the assignment, we need the dentry to do the removal:
> 
> void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
> {
> 	if (vcpu->arch.debugfs_exit_timing) {
> 		debugfs_remove(vcpu->arch.debugfs_exit_timing);
> 		vcpu->arch.debugfs_exit_timing = NULL;
> 	}
> }
> 
> 
> I squashed this in, which seems to work:
> 
> diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
> index 8e4791c6f2af..5b7a66f86bd5 100644
> --- a/arch/powerpc/kvm/timing.c
> +++ b/arch/powerpc/kvm/timing.c
> @@ -207,19 +207,19 @@ static const struct file_operations kvmppc_exit_timing_fops = {
>  void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
>  {
>         static char dbg_fname[50];
> +       struct dentry *debugfs_file;
>  
>         snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
>                  current->pid, id);
> -       debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
> -                           &kvmppc_exit_timing_fops);
> -
> +       debugfs_file = debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir,
> +                                          vcpu, &kvmppc_exit_timing_fops);
>  
>         vcpu->arch.debugfs_exit_timing = debugfs_file;

That works, yes.

>  }
>  
>  void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  {
> -       if (vcpu->arch.debugfs_exit_timing) {
> +       if (!IS_ERR_OR_NULL(vcpu->arch.debugfs_exit_timing)) {
>                 debugfs_remove(vcpu->arch.debugfs_exit_timing);
>                 vcpu->arch.debugfs_exit_timing = NULL;
>         }

No, this can just be:
	debugfs_remove(vcpu->arch.debugfs_exit_timing);

No need to check anything, just call it and the debugfs code can handle
it just fine.

thanks,

greg k-h
