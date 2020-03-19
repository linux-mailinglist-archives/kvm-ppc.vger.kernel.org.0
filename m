Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FA918C3BF
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 00:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgCSXeq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46687 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgCSXeq (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48k3Cm4pkTz9sSK; Fri, 20 Mar 2020 10:34:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584660884; bh=8/nwuYSUP1Qm/RPYgjFE8kvBJjM7phd9M7wZLcqKx/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OR2YdyN3kPXkjJCutfQ6yInoGe/69l6616eQ3CoTSqkVjJRsvEV0gDG5HUIbQSSJ9
         JdiuSDjOcuhC8SWDJZ+5CelrVpH4A8guUabTUw5wHAozZyq+ZuHH6m1EJ8p+sfrB3h
         IkI2x1Z4iVQHbR3Xerv5lbHbSv/u4eh/yfIFh9iXJLHC5esji+ULI1ITdERwy2jAGJ
         CcL4Wy52sg9ED5/C8Ka/VxNo2h9eyMRKhekcLuY9qQBaucLALPwc94mp72TWYWbni4
         i6dpoCVUPVhJg3SbnDIAURTfJiijrXWL41Tr535gb/hJTQHyxK8yKFTnBYy2Xok6Uc
         LFtu0VsLIPHQw==
Date:   Fri, 20 Mar 2020 10:31:19 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Use RADIX_PTE_INDEX_SIZE in Radix
 MMU code
Message-ID: <20200319233118.GB3260@blackberry>
References: <20200218043650.24410-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218043650.24410-1-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Feb 18, 2020 at 03:36:50PM +1100, Michael Ellerman wrote:
> In kvmppc_unmap_free_pte() in book3s_64_mmu_radix.c, we use the
> non-constant value PTE_INDEX_SIZE to clear a PTE page.
> 
> We can instead use the constant RADIX_PTE_INDEX_SIZE, because we know
> this code will only be running when the Radix MMU is active.
> 
> Note that we already use RADIX_PTE_INDEX_SIZE for the allocation of
> kvm_pte_cache.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Thanks, applied to my kvm-ppc-next branch.

Paul.
