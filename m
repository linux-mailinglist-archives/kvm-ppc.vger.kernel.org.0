Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8039CEB0
	for <lists+kvm-ppc@lfdr.de>; Sun,  6 Jun 2021 13:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhFFLhz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 6 Jun 2021 07:37:55 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42603 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhFFLhz (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 6 Jun 2021 07:37:55 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FyZFd0211z9sW8; Sun,  6 Jun 2021 21:36:04 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210526120005.3432222-1-npiggin@gmail.com>
References: <20210526120005.3432222-1-npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Fix reverse map real-mode address lookup with huge vmalloc
Message-Id: <162297929320.2342154.13861620404676525941.b4-ty@ellerman.id.au>
Date:   Sun, 06 Jun 2021 21:34:53 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 26 May 2021 22:00:05 +1000, Nicholas Piggin wrote:
> real_vmalloc_addr() does not currently work for huge vmalloc, which is
> what the reverse map can be allocated with for radix host, hash guest.
> 
> Extract the hugepage aware equivalent from eeh code into a helper, and
> convert existing sites including this one to use it.

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV: Fix reverse map real-mode address lookup with huge vmalloc
      https://git.kernel.org/powerpc/c/5362a4b6ee6136018558ef6b2c4701aa15ebc602

cheers
