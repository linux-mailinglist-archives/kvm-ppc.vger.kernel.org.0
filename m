Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16581F6E18
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Nov 2019 06:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfKKF2M (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Nov 2019 00:28:12 -0500
Received: from ozlabs.org ([203.11.71.1]:45595 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfKKF2L (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 11 Nov 2019 00:28:11 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47BKCY6XtWz9sPn; Mon, 11 Nov 2019 16:28:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573450089; bh=Gk49bVSafO6qIOkqpX6nJCaX1ioKZx1OXiY1Eid0yQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzO9kkm++WvSl259JyipYeMhoPff9fwIU5yZswgTFotSFTW8+QyqmIoXIsPh8/GWx
         C1d7HZsIxm7gjhzHagA36jMYph6dSnsKJu4vtzSQpp/NvijxvGXUd14h13HucKCJnV
         P/Y+PyMcPtwNQr2pqrJgmCD9OmL7bQaTwBiW+p3Lne0GkchrCKb6S2sP+Je+g3YgQp
         1zMuYge180wtE6ElW8JGmUgzb6CjWrpCCFL4TD1w6KshiemCO4opWIUzd6F+TVNquI
         qvtQ5FLv7KjaWBTKtAVWDy9a5bbcZCaJp1jxbphDRimvSNLEWgwj8xGkbf7PM+HiaL
         aS+a880rDPU/Q==
Date:   Mon, 11 Nov 2019 16:28:06 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 6/8] KVM: PPC: Support reset of secure guest
Message-ID: <20191111052806.GC4017@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-7-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-7-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:58AM +0530, Bharata B Rao wrote:
> Add support for reset of secure guest via a new ioctl KVM_PPC_SVM_OFF.
> This ioctl will be issued by QEMU during reset and includes the
> the following steps:
> 
> - Ask UV to terminate the guest via UV_SVM_TERMINATE ucall
> - Unpin the VPA pages so that they can be migrated back to secure
>   side when guest becomes secure again. This is required because
>   pinned pages can't be migrated.

Unpinning the VPA pages is normally handled during VM reset by QEMU
doing set_one_reg operations to set the values for the
KVM_REG_PPC_VPA_ADDR, KVM_REG_PPC_VPA_SLB and KVM_REG_PPC_VPA_DTL
pseudo-registers to zero.  Is there some reason why this isn't
happening for a secure VM, and if so, what is that reason?
If it is happening, then why do we need to unpin the pages explicitly
here?

> - Reinitialize guest's partitioned scoped page tables. These are
>   freed when guest becomes secure (H_SVM_INIT_DONE)

It doesn't seem particularly useful to me to free the partition-scoped
page tables when the guest becomes secure, and it feels like it makes
things more fragile.  If you don't free them then, then you don't need
to reallocate them now.

> - Release all device pages of the secure guest.
> 
> After these steps, guest is ready to issue UV_ESM call once again
> to switch to secure mode.

Paul.
