Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46962F3C9
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Apr 2019 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfD3KLz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Apr 2019 06:11:55 -0400
Received: from ozlabs.org ([203.11.71.1]:51087 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbfD3KLz (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:55 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tckx5TWNz9sB3; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619113; bh=ZExBJgWo/ZtEMfDFYbQw8GGjN/VJ+NC9Of9Kq3R6MhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrEdSTcibQhyUHbZ8yrZY+dNXJIP+AuxWPr2bxlCcyEAo7Pirtnmoigs+O1JTaiYQ
         wF7xmvrqPvQAPZ6iZ3Ysju/PxViocAMnEqjtnwfykQhdVhJa6dL4gsyTsSTqan0njy
         J326cUMotW1LjSErdulKdx7ThLLBBWjafFcYa3WmY1qy7S4Iqs5Zb0FbmtMp46TQzR
         l5WFJo/QoLzzJ8JcDPzr6splRzUOzAavgM8t0m+Z4Mf+xlW3xc4Fky3bsy4jNtf40G
         5TLv8sH0CdOKkQid1fhGDMTvPB6NUkCUhndCdSBu8ofdE/HRtEznbMObtD/s3+nuna
         Fq/SBtrSGL7MA==
Date:   Tue, 30 Apr 2019 20:02:56 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v4] KVM: PPC: Allocate guest TCEs on demand too
Message-ID: <20190430100256.GE32205@blackberry>
References: <20190329054326.48275-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329054326.48275-1-aik@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 29, 2019 at 04:43:26PM +1100, Alexey Kardashevskiy wrote:
> We already allocate hardware TCE tables in multiple levels and skip
> intermediate levels when we can, now it is a turn of the KVM TCE tables.
> Thankfully these are allocated already in 2 levels.
> 
> This moves the table's last level allocation from the creating helper to
> kvmppc_tce_put() and kvm_spapr_tce_fault(). Since such allocation cannot
> be done in real mode, this creates a virtual mode version of
> kvmppc_tce_put() which handles allocations.
> 
> This adds kvmppc_rm_ioba_validate() to do an additional test if
> the consequent kvmppc_tce_put() needs a page which has not been allocated;
> if this is the case, we bail out to virtual mode handlers.
> 
> The allocations are protected by a new mutex as kvm->lock is not suitable
> for the task because the fault handler is called with the mmap_sem held
> but kvmhv_setup_mmu() locks kvm->lock and mmap_sem in the reverse order.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks, patch applied to my kvm-ppc-next tree.

Paul.
