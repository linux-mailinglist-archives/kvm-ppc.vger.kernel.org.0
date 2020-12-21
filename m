Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054CB2DFB50
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Dec 2020 12:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgLULEQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Dec 2020 06:04:16 -0500
Received: from ozlabs.org ([203.11.71.1]:44441 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgLULEQ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Dec 2020 06:04:16 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CzxRB3J50z9sW0; Mon, 21 Dec 2020 22:03:34 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>,
        paulus@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kaixu Xia <kaixuxia@tencent.com>
In-Reply-To: <1604764178-8087-1-git-send-email-kaixuxia@tencent.com>
References: <1604764178-8087-1-git-send-email-kaixuxia@tencent.com>
Subject: Re: [PATCH] KVM: PPC: fix comparison to bool warning
Message-Id: <160854857735.1696279.7271501968422193130.b4-ty@ellerman.id.au>
Date:   Mon, 21 Dec 2020 22:03:34 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 7 Nov 2020 23:49:38 +0800, xiakaixu1987@gmail.com wrote:
> Fix the following coccicheck warning:
> 
> ./arch/powerpc/kvm/booke.c:503:6-16: WARNING: Comparison to bool
> ./arch/powerpc/kvm/booke.c:505:6-17: WARNING: Comparison to bool
> ./arch/powerpc/kvm/booke.c:507:6-16: WARNING: Comparison to bool

Applied to powerpc/next.

[1/1] KVM: PPC: fix comparison to bool warning
      https://git.kernel.org/powerpc/c/a300bf8c5f24bdeaa84925d1e0ec6221cbdc7597

cheers
