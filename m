Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20723131C65
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 Jan 2020 00:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgAFXdY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 6 Jan 2020 18:33:24 -0500
Received: from ozlabs.org ([203.11.71.1]:35085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgAFXdU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 6 Jan 2020 18:33:20 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47sBdp41NSz9sRf; Tue,  7 Jan 2020 10:33:18 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: d862b44133b7a1d7de25288e09eabf4df415e971
In-Reply-To: <20191216041924.42318-2-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v2 1/4] Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests"
Message-Id: <47sBdp41NSz9sRf@ozlabs.org>
Date:   Tue,  7 Jan 2020 10:33:18 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-12-16 at 04:19:21 UTC, Alexey Kardashevskiy wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> This reverts commit edea902c1c1efb855f77e041f9daf1abe7a9768a.
> 
> At the time the change allowed direct DMA ops for secure VMs; however
> since then we switched on using SWIOTLB backed with IOMMU (direct mapping)
> and to make this work, we need dma_iommu_ops which handles all cases
> including TCE mapping I/O pages in the presence of an IOMMU.
> 
> Fixes: edea902c1c1e ("powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests")
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [aik: added "revert" and "fixes:"]
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/d862b44133b7a1d7de25288e09eabf4df415e971

cheers
