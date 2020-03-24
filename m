Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1721903B8
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 Mar 2020 03:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgCXC43 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 23 Mar 2020 22:56:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34297 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgCXC43 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 23 Mar 2020 22:56:29 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48mbVg1D2nz9sSH; Tue, 24 Mar 2020 13:56:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1585018587; bh=qcqkAGfatCcdaSF4JecPaLJRR36leDyxRC3RwY8oO3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1S6P/UZ1s9Q7htiPyHTtAlm1CEfR6MJvQadZpArIv5YrDEMKNc+Zkd73fIwGD3IX
         HS+zH7c5SS13rccwa7v0NYBzLVY/7uELpZMD5FFPUcmUbeTsU+AnsKET43qGKnS2S/
         CKm3NjDvUrwZEG3zvZpY2VIEGBri+iCC2PPkeVctiVSUBdpdbI6EiOkwquLkXzLd7u
         4V9/iAr9M6Z+E5X8kPkYCQrOBNg9Ri6Eszroac4IZGcxoTZ+VKnCj+Ooc3YZtt/MmY
         4COXK9PBfN7EgldeacQ4ySFbgWaarKd2CSEL6OS5ZTSPJ1lISoAv4LO/qbkmEr46ty
         bPHlD35Z1l10g==
Date:   Tue, 24 Mar 2020 13:54:29 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix SVM hang at startup
Message-ID: <20200324025429.GD5604@blackberry>
References: <20200320102643.15516-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320102643.15516-1-ldufour@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 20, 2020 at 11:26:41AM +0100, Laurent Dufour wrote:
> This series is fixing a SVM hang occurring when starting a SVM requiring
> more secure memory than available. The hang happens in the SVM when calling
> UV_ESM.
> 
> The following is happening:
> 
> 1. SVM calls UV_ESM
> 2. Ultravisor (UV) calls H_SVM_INIT_START
> 3. Hypervisor (HV) calls UV_REGISTER_MEM_SLOT
> 4. UV returns error because there is not enough free secure memory
> 5. HV enter the error path in kvmppc_h_svm_init_start()
> 6. In the return path, since kvm->arch.secure_guest is not yet set hrfid is
>    called
> 7. As the HV doesn't know the SVM calling context hrfid is jumping to
>    unknown address in the SVM leading to various expections.
> 
> This series fixes the setting of kvm->arch.secure_guest in
> kvmppc_h_svm_init_start() to ensure that UV_RETURN is called on the return
> path to get back to the UV.
> 
> In addition to ensure that a malicious VM will not call UV reserved Hcall,
> a check of the Secure bit in the calling MSR is addded to reject such a
> call.
> 
> It is assumed that the UV will filtered out such Hcalls made by a malicious
> SVM.
> 
> Laurent Dufour (2):
>   KVM: PPC: Book3S HV: check caller of H_SVM_* Hcalls
>   KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN
> 
>  arch/powerpc/kvm/book3s_hv.c       | 32 ++++++++++++++++++++----------
>  arch/powerpc/kvm/book3s_hv_uvmem.c |  3 ++-
>  2 files changed, 23 insertions(+), 12 deletions(-)

Thanks, series applied to my kvm-ppc-next branch.

Paul.
