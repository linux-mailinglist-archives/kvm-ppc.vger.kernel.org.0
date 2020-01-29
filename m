Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2E914C590
	for <lists+kvm-ppc@lfdr.de>; Wed, 29 Jan 2020 06:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgA2FR3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 29 Jan 2020 00:17:29 -0500
Received: from ozlabs.org ([203.11.71.1]:42489 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgA2FR2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 29 Jan 2020 00:17:28 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 486sDl09qNz9sRh; Wed, 29 Jan 2020 16:17:26 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 736bcdd3a9fc672af33fb83230ecd0570ec38ec6
In-Reply-To: <20191206031722.25781-1-jniethe5@gmail.com>
To:     Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     oohall@gmail.com, Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH v3] powerpc/mm: Remove kvm radix prefetch workaround for Power9 DD2.2
Message-Id: <486sDl09qNz9sRh@ozlabs.org>
Date:   Wed, 29 Jan 2020 16:17:26 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 2019-12-06 at 03:17:22 UTC, Jordan Niethe wrote:
> Commit a25bd72badfa ("powerpc/mm/radix: Workaround prefetch issue with
> KVM") introduced a number of workarounds as coming out of a guest with
> the mmu enabled would make the cpu would start running in hypervisor
> state with the PID value from the guest. The cpu will then start
> prefetching for the hypervisor with that PID value.
> 
> In Power9 DD2.2 the cpu behaviour was modified to fix this. When
> accessing Quadrant 0 in hypervisor mode with LPID != 0 prefetching will
> not be performed. This means that we can get rid of the workarounds for
> Power9 DD2.2 and later revisions. Add a new cpu feature
> CPU_FTR_P9_RADIX_PREFETCH_BUG to indicate if the workarounds are needed.
> 
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/736bcdd3a9fc672af33fb83230ecd0570ec38ec6

cheers
