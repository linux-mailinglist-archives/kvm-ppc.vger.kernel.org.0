Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EEE2DFB53
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Dec 2020 12:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgLULEk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Dec 2020 06:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgLULEk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Dec 2020 06:04:40 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46886C061248;
        Mon, 21 Dec 2020 03:03:36 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CzxR95HsHz9sVn; Mon, 21 Dec 2020 22:03:33 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        paulus@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
References: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
Subject: Re: [PATCH] KVM: PPC: Book3S: Assign boolean values to a bool variable
Message-Id: <160854857711.1696279.4751962341706112640.b4-ty@ellerman.id.au>
Date:   Mon, 21 Dec 2020 22:03:33 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 7 Nov 2020 14:26:22 +0800, xiakaixu1987@gmail.com wrote:
> Fix the following coccinelle warnings:
> 
> ./arch/powerpc/kvm/book3s_xics.c:476:3-15: WARNING: Assignment of 0/1 to bool variable
> ./arch/powerpc/kvm/book3s_xics.c:504:3-15: WARNING: Assignment of 0/1 to bool variable

Applied to powerpc/next.

[1/1] KVM: PPC: Book3S: Assign boolean values to a bool variable
      https://git.kernel.org/powerpc/c/13751f8747519fe3bdc738fa6d802fbd94a85ac4

cheers
