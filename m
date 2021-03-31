Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717B234F7CD
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhCaEVM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhCaEU5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 00:20:57 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FFFC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Mar 2021 21:20:57 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9CmR3vGHz9sWQ; Wed, 31 Mar 2021 15:20:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617164455; bh=wCCS9x+0BkoEX0cVVG+0NhLVg9XU1CuM70ITQy8JHDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BKD9ckIuW6EnC9ffmjIC3iQ/aivwmDsUaoQEjocIdV3hSsRTZAzKCCAXTWrwwVG5z
         Wi8V+ICzuDfBQcozE6O7qNKgcp7y57bgSFQYETDTzTheumKhwIYT2jN7elMQj5inIv
         4I31Gj90JOJ+VRHGvmTcagUZInlcQtlSF+Ro20tWLUhaCF8qusckMOULCQGYymOlH0
         z880TMaIm3fvwCCy9/KFtFlSPoFdWF+N2KzzXHa2Rh66EvvgP6IPIDiEip8dJncpS4
         dRpVGmOVh4VhHnDQ9qiWWNmRXoB57tRcN4GwEQPSnjsUnvxBaO84eRtU4ZeEdE8wMa
         tJt3hQPiyEzzA==
Date:   Wed, 31 Mar 2021 13:47:12 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 01/46] KVM: PPC: Book3S HV: Nested move LPCR
 sanitising to sanitise_hv_regs
Message-ID: <YGPisFlG2VjX05iZ@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-2-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-2-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:20AM +1000, Nicholas Piggin wrote:
> This will get a bit more complicated in future patches. Move it
> into the helper function.

This does change L1-visible behaviour, because now the L1 hypervisor
can see the LPCR bits that L0 is using, whereas previously it couldn't
(and that was deliberate).  I can't point to a specific scenario where
that is a real problem, but nevertheless it worries me.  And the
behaviour change should have been mentioned in the commit message at
least.

Paul.
