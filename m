Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD230140277
	for <lists+kvm-ppc@lfdr.de>; Fri, 17 Jan 2020 04:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgAQDoU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 16 Jan 2020 22:44:20 -0500
Received: from ozlabs.org ([203.11.71.1]:41301 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbgAQDoT (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 16 Jan 2020 22:44:19 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47zRkn4PZZz9sRd; Fri, 17 Jan 2020 14:44:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579232657; bh=ltSUYl1RDYBIGn9bPmKjAqMNA4aASu38qTLJ2lZkEmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRpG3pi7GFi82Qba6Pzm7uB4nfP9Nr3XKcwo53umfhcl1ylDaP8aSeCiGvQLvrRNH
         9UgQTp523GqjiRHNU3+3yCMjIWcfLD1WiZLF07pUHNnLn/tsgz61WJ5TWluBb48Iev
         Hs7nl4B06xm282BE7/4zRUzj+CuQH4oAIHMKH6Q+zNRlghHbP3dYkMibYMIS54/r/P
         qhOUwkUNS3cIL2DohqyqXf47gYURRje8UIo5txvYuite4BHSqq38N+HBxswvrZVT9P
         WF8rlCMO6t1soIhmpiYHWdE/uEJL7VWuccRAMzb4Ta8Yl1vJyaRV/wBqK+lOR8lqfm
         I9gcUrjyuB5Pg==
Date:   Fri, 17 Jan 2020 14:43:54 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        oohall@gmail.com, mpe@ellerman.id.au
Subject: Re: [PATCH v3] powerpc/mm: Remove kvm radix prefetch workaround for
 Power9 DD2.2
Message-ID: <20200117034354.GA31793@blackberry>
References: <20191206031722.25781-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206031722.25781-1-jniethe5@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Dec 06, 2019 at 02:17:22PM +1100, Jordan Niethe wrote:
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

Acked-by: Paul Mackerras <paulus@ozlabs.org>
