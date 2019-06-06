Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F35C37418
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 14:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfFFM1r (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 08:27:47 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38181 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfFFM1r (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 08:27:47 -0400
Received: by mail-wr1-f45.google.com with SMTP id d18so2221137wrs.5
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 05:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hbLFNTopAAAv8+LY8MCYOAfcR3BUyaTeuA+JuFQuZ8o=;
        b=U3HprbmxL6WkAq/Zk+YTB+e3ZQw8Hkjc6d3VtC1vxxr1OfFz1e27xD+7sux+K2v25c
         sj06YbemLlJdpS1xOo7IQ92wuOsLaFGm3UUb2R0hBoZPMvU+9Xukjd/I+WxSmsrwf4m2
         BnzDhMyZjN0zhOvamawNBgqLmNbEfXm7j8ZgVqWb2qEWZnaK19QICRcoT9rXb77lHT6M
         yF55Wa0FLj3Dp5yxndXeQ45y8Jxnm9kqGll5+NL2GM1fMqBR5xszrrXNWsI7fCVyIxgn
         r+uCntuxWsQ3UlBeqTX6lfqP03rfmZAkG2m80WsXzjLchUkwgjZqMExMFfIGcQwUsm2J
         vdaQ==
X-Gm-Message-State: APjAAAUx9WMphJ5nieJNtrsznRHgyL7TJclt/Hk7mBS3mObQzJiPlVVR
        KMLxRgYDruMy37dntVFIQP7/8w==
X-Google-Smtp-Source: APXvYqzQ6CBDmgu64hT4KHJ/lQ/AcFOI1nj9C9ISdvzJX1Gt/PbIMEF+apdvOpVHZI0ighsZ20TP5w==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr13070924wru.264.1559824065369;
        Thu, 06 Jun 2019 05:27:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id r5sm506401wrg.10.2019.06.06.05.27.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:27:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 0/2] Ppc next patches
To:     Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        David Gibson <dgibson@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
 <ee1e0c40-b026-f324-58aa-cc01bd58b1a6@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d544bb5-4bbd-7485-dd91-4a764011a422@redhat.com>
Date:   Thu, 6 Jun 2019 14:27:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ee1e0c40-b026-f324-58aa-cc01bd58b1a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 03/06/19 10:24, Laurent Vivier wrote:
> Radim, Paolo,
> 
> is there something that prevents this PR to be merged?

FWIW I was just waiting for the merge window waters to settle down, so
that I could go through all the pending patches for both KVM and
kvm-unit-tests.

Paolo

> Thanks,
> Laurent
> 
> On 17/05/2019 15:03, Laurent Vivier wrote:
>> The following changes since commit 14bc602f3479d3f5c5e11034daa1070c61bd5640:
>>
>>   Merge tag 'pull-request-2019-04-19' of https://gitlab.com/huth/kvm-unit-tests (2019-05-03 10:53:30 -0600)
>>
>> are available in the Git repository at:
>>
>>   https://github.com/vivier/kvm-unit-tests.git tags/ppc-next-pull-request
>>
>> for you to fetch changes up to aa3a3a9e6654fce23a78141c8cfadcd6ba871af1:
>>
>>   powerpc: Make h_cede_tm test run by default (2019-05-17 13:50:47 +0200)
>>
>> ----------------------------------------------------------------
>> Fix h_cede_tm timeout
>>
>> ----------------------------------------------------------------
>>
>> Suraj Jitindar Singh (2):
>>   powerpc: Allow for a custom decr value to be specified to load on decr
>>     excp
>>   powerpc: Make h_cede_tm test run by default
>>
>>  lib/powerpc/handlers.c | 7 ++++---
>>  powerpc/sprs.c         | 3 ++-
>>  powerpc/tm.c           | 4 +++-
>>  powerpc/unittests.cfg  | 2 +-
>>  4 files changed, 10 insertions(+), 6 deletions(-)
>>
> 

