Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E23431975D
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Feb 2021 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhBLAUm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Feb 2021 19:20:42 -0500
Received: from ozlabs.org ([203.11.71.1]:38085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhBLAUk (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 11 Feb 2021 19:20:40 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4DcDf63D5dz9sVs; Fri, 12 Feb 2021 11:19:58 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     paulus@ozlabs.org, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1612680192-43116-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1612680192-43116-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] powerpc/xive: Assign boolean values to a bool variable
Message-Id: <161308904033.3606979.1053940851108095108.b4-ty@ellerman.id.au>
Date:   Fri, 12 Feb 2021 11:19:58 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, 7 Feb 2021 14:43:12 +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./arch/powerpc/kvm/book3s_xive.c:1856:2-17: WARNING: Assignment of 0/1
> to bool variable.
> 
> ./arch/powerpc/kvm/book3s_xive.c:1854:2-17: WARNING: Assignment of 0/1
> to bool variable.

Applied to powerpc/next.

[1/1] powerpc/xive: Assign boolean values to a bool variable
      https://git.kernel.org/powerpc/c/c9df3f809cc98b196548864f52d3c4e280dd1970

cheers
