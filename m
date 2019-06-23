Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C914FB6F
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 Jun 2019 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfFWMDm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 Jun 2019 08:03:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:35026 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbfFWMDm (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 23 Jun 2019 08:03:42 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x5NC3XvW018219;
        Sun, 23 Jun 2019 07:03:33 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x5NC3Wup018218;
        Sun, 23 Jun 2019 07:03:32 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Sun, 23 Jun 2019 07:03:32 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc/64s: Rename PPC_INVALIDATE_ERAT to PPC_ARCH_300_INVALIDATE_ERAT
Message-ID: <20190623120332.GA7313@gate.crashing.org>
References: <20190623104152.13173-1-npiggin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623104152.13173-1-npiggin@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, Jun 23, 2019 at 08:41:51PM +1000, Nicholas Piggin wrote:
> This makes it clear to the caller that it can only be used on POWER9
> and later CPUs.

> -#define PPC_INVALIDATE_ERAT	PPC_SLBIA(7)
> +#define PPC_ARCH_300_INVALIDATE_ERAT	PPC_SLBIA(7)

The architecture version is 3.0 (or 3.0B), not "300".  This will work on
implementations of later architecture versions as well, so maybe the name
isn't so great anyway?


Segher
