Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A660017704B
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 08:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgCCHqb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 02:46:31 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:44955 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgCCHqb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 3 Mar 2020 02:46:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Wpwz32jpz9sRN;
        Tue,  3 Mar 2020 18:46:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1583221587;
        bh=G1j2yPc6TZuk6knho/y0IRPor8p+O16lsXUZwEsoC2M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Hugua8/KViy89SYtS1gBraSgOVAnqQXkj8bZtK3YMnaS3PnhFarORILJqaM6omWT3
         dwYOrcYRZJLM2REKUkkUNOEwCZn4h8b1izz9ZxUC0hcpLQ2P+OnLo+o5VYzVCXulxQ
         TInCZixKl7pTsn18UfIk7g636Q65F7oPrSMNbculoJWS7ib3cw+mlaBsFy1Oyx5OYc
         yXXU6vC9LzhPMV0yDdZAuCk+/Owv0xihQWbpfW0no1fq7pEPvcMrF4OcMcGPpcRnSc
         R4T/t5aK+MOIzcylYF5/3x0CRuTIbqBd+omFkB1kLENxLMM4T5dIT42MAybw2vRIaZ
         VkJDx4/v3G0Gg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/6] powerpc: kvm: no need to check return value of debugfs_create functions
In-Reply-To: <20200209105901.1620958-2-gregkh@linuxfoundation.org>
References: <20200209105901.1620958-1-gregkh@linuxfoundation.org> <20200209105901.1620958-2-gregkh@linuxfoundation.org>
Date:   Tue, 03 Mar 2020 18:46:23 +1100
Message-ID: <87imjlswxc.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.

Except it does need to do something different, if the file was created
it needs to be removed in the remove path.

> diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
> index bfe4f106cffc..8e4791c6f2af 100644
> --- a/arch/powerpc/kvm/timing.c
> +++ b/arch/powerpc/kvm/timing.c
> @@ -207,19 +207,12 @@ static const struct file_operations kvmppc_exit_timing_fops = {
>  void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
>  {
>  	static char dbg_fname[50];
> -	struct dentry *debugfs_file;
>  
>  	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
>  		 current->pid, id);
> -	debugfs_file = debugfs_create_file(dbg_fname, 0666,
> -					kvm_debugfs_dir, vcpu,
> -					&kvmppc_exit_timing_fops);
> -
> -	if (!debugfs_file) {
> -		printk(KERN_ERR"%s: error creating debugfs file %s\n",
> -			__func__, dbg_fname);
> -		return;
> -	}
> +	debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
> +			    &kvmppc_exit_timing_fops);
> +
>  
>  	vcpu->arch.debugfs_exit_timing = debugfs_file;
>  }

This doesn't build:

    arch/powerpc/kvm/timing.c:217:35: error: 'debugfs_file' undeclared (first use in this function); did you mean 'debugfs_file_put'?

We can't just drop the assignment, we need the dentry to do the removal:

void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
{
	if (vcpu->arch.debugfs_exit_timing) {
		debugfs_remove(vcpu->arch.debugfs_exit_timing);
		vcpu->arch.debugfs_exit_timing = NULL;
	}
}


I squashed this in, which seems to work:

diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
index 8e4791c6f2af..5b7a66f86bd5 100644
--- a/arch/powerpc/kvm/timing.c
+++ b/arch/powerpc/kvm/timing.c
@@ -207,19 +207,19 @@ static const struct file_operations kvmppc_exit_timing_fops = {
 void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
 {
        static char dbg_fname[50];
+       struct dentry *debugfs_file;
 
        snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
                 current->pid, id);
-       debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir, vcpu,
-                           &kvmppc_exit_timing_fops);
-
+       debugfs_file = debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir,
+                                          vcpu, &kvmppc_exit_timing_fops);
 
        vcpu->arch.debugfs_exit_timing = debugfs_file;
 }
 
 void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-       if (vcpu->arch.debugfs_exit_timing) {
+       if (!IS_ERR_OR_NULL(vcpu->arch.debugfs_exit_timing)) {
                debugfs_remove(vcpu->arch.debugfs_exit_timing);
                vcpu->arch.debugfs_exit_timing = NULL;
        }


cheers
