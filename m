Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC61B2815
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Apr 2020 15:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgDUNhL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Apr 2020 09:37:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728597AbgDUNhK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Apr 2020 09:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587476229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYP1YDlNBMnycORNWlm6IFetMVB2wDT3m1YqxbCNVb0=;
        b=XYKzldiN0nEG0ZRC+uYiT+UJhtg5+3a3FzscuPfgByWSEnDGJZFRKNz9HSPzKQGnUuNycS
        lgPJCLnqLree/hI7OfrhpbhJRpyIQS7cCXRvowHhsxRd0m9SByURc6znfFZ2kWjylBarzU
        vCc1BpM9aSZpOv/evLTNQ/Wv8yrjol8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-gaknmicXNze-9Ic9uHjdFA-1; Tue, 21 Apr 2020 09:37:07 -0400
X-MC-Unique: gaknmicXNze-9Ic9uHjdFA-1
Received: by mail-wr1-f69.google.com with SMTP id j16so7477059wrw.20
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Apr 2020 06:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYP1YDlNBMnycORNWlm6IFetMVB2wDT3m1YqxbCNVb0=;
        b=BWJmIevmoPTJizbxmIKkPd6fDyXJoSg3zjQGcUFsSkPXsoDyc6fOv9UM5J3vF0wweY
         UmgenH9pChSOBES8IGdqCVxebK0FtvsDLj2AM5HHnv9MlZhtyehWIKtmXMD+p0SuMT17
         vJZUWCXYEyXgOQf4m95LMT827Jl/ZmLDnipfW3eja1OlKenoljBWN7QPWDtdWTk5sh+1
         f2QJeizD8JPHoqG3OId/UfoRu2Deqno6uuZ4dtE6fbUhz4Y3pzmrBl4IFbhyDllZ5RuV
         Pzr+y9f5r0mxmPBmMKG9meJpoamX83Pd4ZmkRmBY0V6xjLCZBljTUdeGSl8C0tZo9lOA
         0D9Q==
X-Gm-Message-State: AGi0Puacq3J0RvvNlV7rA8XSd0RBb8k2q0IuPayx+zQtXEwPSQbrtIO3
        2WcESLsiMbw93EKLWnUOqltwS57IQXMyjDqZbWDlD0pUPlVgAswE01kV8QxmgPtUKjdyFDIub63
        yCSAY3DanN4itEcm5VA==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr5283277wmj.161.1587476226734;
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKOBSIDEmyd50iLtny1lI00mt2RU6wtoVbdZptdvKB21AxBx8lJ3LHqNkiNwJOmAw7DTQ0CSQ==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr5283258wmj.161.1587476226531;
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id i17sm3688105wru.39.2020.04.21.06.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:37:06 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.7-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20200420235300.GA7086@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <365dfab9-9f9f-6c6a-7f4f-c5bbf7e67d41@redhat.com>
Date:   Tue, 21 Apr 2020 15:37:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420235300.GA7086@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 21/04/20 01:53, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.7-1

Pulled, thanks.

Paolo

