Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F2618C8
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 03:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfGHBTt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 7 Jul 2019 21:19:49 -0400
Received: from ozlabs.org ([203.11.71.1]:48771 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbfGHBTt (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 7 Jul 2019 21:19:49 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45hng72Df7z9sNs; Mon,  8 Jul 2019 11:19:47 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 4f44e8aeaf1937d9148dfcc4c028cd8aff27902e
In-Reply-To: <1562169853-12593-1-git-send-email-info@metux.net>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     alistair@popple.id.au, kvm-ppc@vger.kernel.org, oss@buserror.net,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] arch: powerpc: Kconfig: pedantic formatting
Message-Id: <45hng72Df7z9sNs@ozlabs.org>
Date:   Mon,  8 Jul 2019 11:19:47 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2019-07-03 at 16:04:13 UTC, "Enrico Weigelt, metux IT consult" wrote:
> Formatting of Kconfig files doesn't look so pretty, so let the
> Great White Handkerchief come around and clean it up.
> 
> Also convert "---help---" as requested on lkml.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/4f44e8aeaf1937d9148dfcc4c028cd8aff27902e

cheers
