Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC06D2630E2
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Sep 2020 17:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIIPsS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Sep 2020 11:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730541AbgIIPrm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Sep 2020 11:47:42 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09DC0617A0
        for <kvm-ppc@vger.kernel.org>; Wed,  9 Sep 2020 06:28:01 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4BmjWM3Hvgz9sVb; Wed,  9 Sep 2020 23:27:59 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
In-Reply-To: <20200825075535.224536-1-npiggin@gmail.com>
References: <20200825075535.224536-1-npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/64s: handle ISA v3.1 local copy-paste context switches
Message-Id: <159965717521.808686.2830329199165686407.b4-ty@ellerman.id.au>
Date:   Wed,  9 Sep 2020 23:27:59 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 25 Aug 2020 17:55:35 +1000, Nicholas Piggin wrote:
> The ISA v3.1 the copy-paste facility has a new memory move functionality
> which allows the copy buffer to be pasted to domestic memory (RAM) as
> opposed to foreign memory (accelerator).
> 
> This means the POWER9 trick of avoiding the cp_abort on context switch if
> the process had not mapped foreign memory does not work on POWER10. Do the
> cp_abort unconditionally there.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/64s: handle ISA v3.1 local copy-paste context switches
      https://git.kernel.org/powerpc/c/dc462267d2d7aacffc3c1d99b02d7a7c59db7c66

cheers
