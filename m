Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D91177438
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 11:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgCCKcW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 05:32:22 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:60365 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgCCKcW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 3 Mar 2020 05:32:22 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48WtcN0RCtz9sPg;
        Tue,  3 Mar 2020 21:32:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1583231540;
        bh=plIVQelLQN+Lhv6LVRXDSOs7Mt1qf+ql5n8cFWM5qC8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=eiOxIkKNxkhy8BuTzjl2C8S7V8FWoaXiEldT4NoOUCn0HUgadrF25e6taTW9pGf1w
         5I64che4K4w228Sj/uxYo0Lw7zi0NJjb+VsYtmOZwU+/3dWjkAe1KfsvGDFG6m/UzB
         KOq6cXj4eEXSpsYkJZof2d1KTxZXD8vGFxOjR3LtMhC9R1Bw2S9CzzZXBjXFVje9UQ
         1O9maQhH6RCyv5+xSdQjDZmwIHeFuU5Fkodz+72JYsA+9qrBTZn72OuwphM2O6LJBQ
         1PF7WZ2ARePgjBcFQGFGN6d8fq3RlFSulZrELavsjYJSYO0TEBe+MUaH6ofC8U3KmR
         m8X8oF93qTwJw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/6] powerpc: kvm: no need to check return value of debugfs_create functions
In-Reply-To: <20200303095849.GA1399072@kroah.com>
References: <20200209105901.1620958-1-gregkh@linuxfoundation.org> <20200209105901.1620958-2-gregkh@linuxfoundation.org> <87imjlswxc.fsf@mpe.ellerman.id.au> <20200303085039.GA1323622@kroah.com> <87d09tsrf0.fsf@mpe.ellerman.id.au> <20200303095849.GA1399072@kroah.com>
Date:   Tue, 03 Mar 2020 21:32:19 +1100
Message-ID: <874kv5sp8s.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Tue, Mar 03, 2020 at 08:45:23PM +1100, Michael Ellerman wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> > On Tue, Mar 03, 2020 at 06:46:23PM +1100, Michael Ellerman wrote:
>> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> >> > When calling debugfs functions, there is no need to ever check the
>> >> > return value.  The function can work or not, but the code logic should
>> >> > never do something different based on this.
>> >> 
>> >> Except it does need to do something different, if the file was created
>> >> it needs to be removed in the remove path.
>> >> 
>> >> > diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
>> >> > index bfe4f106cffc..8e4791c6f2af 100644
>> >> > --- a/arch/powerpc/kvm/timing.c
>> >> > +++ b/arch/powerpc/kvm/timing.c
>> >> > @@ -207,19 +207,12 @@ static const struct file_operations kvmppc_exit_timing_fops = {
>> >> >  void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
>> >> >  {
>> >> >  	static char dbg_fname[50];
>> >> > -	struct dentry *debugfs_file;
>> >> >  
>> >> >  	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
>> >> >  		 current->pid, id);
>> >> > -	debugfs_file = debugfs_create_file(dbg_fname, 0666,
>> >> > -					kvm_debugfs_dir, vcpu,
>> >> > -					&kvmppc_exit_timing_fops);
>> >> > -
>> >> > -	if (!debugfs_file) {
>> >> > -		printk(KERN_ERR"%s: error creating debugfs file %s\n",
>> >> > -			__func__, dbg_fname);
>> >> > -		return;
>> >> > -	}
>> >> > +	debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
>> >> > +			    &kvmppc_exit_timing_fops);
>> >> > +
>> >> >  
>> >> >  	vcpu->arch.debugfs_exit_timing = debugfs_file;
>> >
>> > Ugh, you are right, how did I miss that?  How is 0-day missing this?
>> > It's been in my tree for a long time, odd.
>> 
>> This code isn't enabled by default, or in any defconfig. So it's only
>> allmodconfig that would trip it, I guess 0-day isn't doing powerpc
>> allmodconfig builds.
>> 
>> >> I squashed this in, which seems to work:
>> ...
>> >>  
>> >>  void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
>> >>  {
>> >> -       if (vcpu->arch.debugfs_exit_timing) {
>> >> +       if (!IS_ERR_OR_NULL(vcpu->arch.debugfs_exit_timing)) {
>> >>                 debugfs_remove(vcpu->arch.debugfs_exit_timing);
>> >>                 vcpu->arch.debugfs_exit_timing = NULL;
>> >>         }
>> >
>> > No, this can just be:
>> > 	debugfs_remove(vcpu->arch.debugfs_exit_timing);
>> >
>> > No need to check anything, just call it and the debugfs code can handle
>> > it just fine.
>> 
>> Oh duh, of course, I should have checked.
>> 
>> I'd still like to NULL out the debugfs_exit_timing member, so I'll do:
>> 
>> void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
>> {
>> 	debugfs_remove(vcpu->arch.debugfs_exit_timing);
>> 	vcpu->arch.debugfs_exit_timing = NULL;
>> }
>
> Fair enough, but I doubt it ever matters :)

Yeah, but I'm paranoid and I have no way to test this code :)

> Thanks for the fixups, sorry for sending a broken patch, my fault.

No worries, we have too many CONFIG options.

cheers
