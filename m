Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8572F6D89
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Nov 2019 05:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfKKEYv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 10 Nov 2019 23:24:51 -0500
Received: from ozlabs.org ([203.11.71.1]:60487 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfKKEYv (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 10 Nov 2019 23:24:51 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47BHpS2k5Nz9sQw; Mon, 11 Nov 2019 15:24:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573446288; bh=nOjRCApbbLW3ygZm3Duw/OcFxSDsQlgMg9b2UyyPd2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2sIvMiPlwtkspPnzggF2f2pHlkVxKzwWV5++ePfcohaqzAz4TdGnSlvy/kpwkgle
         e+GuFJEZTb8n2GC40b6OODmqjS0VA5HBBc/bkfw1mdeoI+tbG78HApErLIH/z/fmzW
         W4AyBHx7crQsGTADwlAfs7Ig3d42vavbAyky11PfXEZXXuWPRl4Yx6ipOnHKyGzL/b
         mYSxxU0P0K8x/FJ7/PFpPh3iHPGkPlhQGpxWrjZ5d70HSO4ob6i5KvQknpBHNftUyN
         5VLnxWU1YOcTiaZYcdADpGOSz2GSkj1kO3AGt1xIOeD2xoZoOLybf/bvQPzfIEvUSz
         5IoXEwLtzDzXQ==
Date:   Mon, 11 Nov 2019 15:19:24 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Ram Pai <linuxram@linux.ibm.com>
Subject: Re: [PATCH v10 7/8] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Message-ID: <20191111041924.GA4017@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-8-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-8-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:59AM +0530, Bharata B Rao wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> Implement the H_SVM_INIT_ABORT hcall which the Ultravisor can use to
> abort an SVM after it has issued the H_SVM_INIT_START and before the
> H_SVM_INIT_DONE hcalls. This hcall could be used when Ultravisor
> encounters security violations or other errors when starting an SVM.
> 
> Note that this hcall is different from UV_SVM_TERMINATE ucall which
> is used by HV to terminate/cleanup an SVM.
> 
> In case of H_SVM_INIT_ABORT, we should page-out all the pages back to
> HV (i.e., we should not skip the page-out). Otherwise the VM's pages,
> possibly including its text/data would be stuck in secure memory.
> Since the SVM did not go secure, its MSR_S bit will be clear and the
> VM wont be able to access its pages even to do a clean exit.

It seems fragile to me to have one more transfer back into the
ultravisor after this call.  Why does the UV need to do this call and
then get control back again one more time?  Why can't the UV defer
doing this call until it can do it without expecting to see a return
from the hcall?  And if it does need to see a return from the hcall,
what would happen if a malicious hypervisor doesn't do the return?

Paul.
