Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C6517B2E4
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Mar 2020 01:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCFA1q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 19:27:46 -0500
Received: from ozlabs.org ([203.11.71.1]:58955 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgCFA1e (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 5 Mar 2020 19:27:34 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48YT381z9Zz9sRY; Fri,  6 Mar 2020 11:27:32 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: c4b78169e3667413184c9a20e11b5832288a109f
In-Reply-To: <20191223060351.26359-1-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, Jan Kara <jack@suse.cz>,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v3] powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()
Message-Id: <48YT381z9Zz9sRY@ozlabs.org>
Date:   Fri,  6 Mar 2020 11:27:32 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-12-23 at 06:03:51 UTC, Alexey Kardashevskiy wrote:
> The last jump to free_exit in mm_iommu_do_alloc() happens after page
> pointers in struct mm_iommu_table_group_mem_t were already converted to
> physical addresses. Thus calling put_page() on these physical addresses
> will likely crash.
> 
> This moves the loop which calculates the pageshift and converts page
> struct pointers to physical addresses later after the point when
> we cannot fail; thus eliminating the need to convert pointers back.
> 
> Fixes: eb9d7a62c386 ("powerpc/mm_iommu: Fix potential deadlock")
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/c4b78169e3667413184c9a20e11b5832288a109f

cheers
