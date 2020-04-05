Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7628419EE22
	for <lists+kvm-ppc@lfdr.de>; Sun,  5 Apr 2020 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgDEUuv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 5 Apr 2020 16:50:51 -0400
Received: from mout.web.de ([212.227.17.12]:60503 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgDEUuv (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 5 Apr 2020 16:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586119837;
        bh=L5/N3xSigmklxeD1ymKp+JH5BKifrxRltrU6xDXr994=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=lPpOONeojMQXhKX8kUlmb9IRKvBGGbIQixh2tVEWdhNrVJ42q3nYes550LtJFBaLP
         TfNd2+w9nTmV+HVLlcPE1mvvFh3ree1dc9Ceod9jw3CVQRiWZpjSlk3NS+6rrTiiKW
         AKxDJIuhAn4xg7AKr1zOELQf5FO1yKLOAIFHKNgg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.131.99.70]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LnjFb-1ipBWE0jGB-00huTv; Sun, 05
 Apr 2020 22:50:37 +0200
To:     Qiujun Huang <hqjagain@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Zhou <chenzhou10@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Remove NULL check before kfree
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a2e4aca0-8e3a-2496-b9a3-ccacf41fd3d9@web.de>
Date:   Sun, 5 Apr 2020 22:50:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:80B/Aal5AECJPwEtbqkk0UHESLMz2OExeU8BxY0Qi+hRjMDcF7M
 DEDZljjKE1kjhvFQeKXwPN3/nAvVXDSKFDmk6bxs++iMfeq62w3pxcV5Rx/KCELMNP8FjpC
 YSsCozqDKXT+/zptYMdUXZloHyBui4hDQL7Z8th/QZYlJiYEZgoC7sS7TkkpTgxHzAaM3ZO
 LaKcO/tWs2IUjWBAhX1UQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PxytlMBUUkQ=:NyAbuMd1btVCqKj8DqO67O
 +YvcLsrm4Zj/9azZu/GBofVeLCJlUZRiiT2J256YzrUJdmeDE/3J8O+NMK4E7xlUHQInych6n
 AnFlcjZ6R6Y+jIXFVLUWWAJ4rjRvHeykjvI8EIMtQWeC9BxeCVa9LsTsGt5IZM79wp2bfpGxs
 hhOzh48lsyrLBvZ2WFT/sNHyX5wTnxrbf+GAW++p+xT1JUC02WoFF4nIDSYmO/FPIaPw1PG4G
 CNSfIK38jKeYFqg54c+p03JvUlT1PkX/josKkZMu21mdBvxYBqsEiVKQsMNvgLNReP8LYPOrU
 XnjpdWIE3XwpSOXY2fMEDWq4JseXyEa2AHAXpcbdHeQhb0hOojjS3Hlncb6hQaJqj3o8sYvOW
 tX91hH3mfCW3rnl6H80ZhA8nkvABvnHoaDN5FmFD11ao9pF6RpDbn3iUzQ3kIJuHQ7Sj0r6U9
 E29OxiCokvYwRxDtoYlg3XYgx+8AR7FWbAHBa+G/GFVcA7KffdWp/19kfrHTFSXn/9qyoT8TK
 PTBerJ3t2y8wdn6YZ7g+Nl+z1S3DFs1v71G7IyKGUnaZiVE3lTmSlggeppgtlGnIlO8W5PD7N
 exKSzgV4ThrZ9yQdohVYL3eesOc/Q5gaIsW0IUfSJ6tvWXvkux333uiBNiPHifMmZz/4gpzSr
 96LeliCUTis01LB7f3nK1YVE3qT+ZMTIWPwoqJCH+Mdi0Y4X3akcXNuvbpqZiK14tLRIkP1JU
 X0FIC9JhtJCCXK0mz7diA6QolnRBFhtfd63mQ+m4U1jLUC+0zALy0lOxfMuKT6M8B9f2+sCXz
 dxzC0fOgrCRWOTQpQKbNamMTpyyb8sIlMF44CsYUv7qxk7NmSHYoimIs/tJ6EM3fIM2MBqk6r
 guBdJ+/gm8yL6eqNlaG4cLAyZkvV0sGFt0p823X5FZJ4EBTfPWVdL5/0/I0p0rtOL1pxlfVru
 6ozqph7lmg4bkJVZpc98WBtjTH9Y/PCR9g5KFmbO+uWfVxcfAKK8R/H3r8ZQCVVoRBWWLKmTU
 3UXTZGDW9pIeEiCcM0I2mGNWIqLMeWThnZnwaO4I/o3qIvJHFWeKiaVzrQTKXMAKnCpqix2hx
 NyAD/NlkMhlhKk+wR9LQelId98J0B7Ix4kJJshIB0DJXaeZjEoCU3XpPP6hGavdPQmUq6foFH
 dhEu+yEFqiTfjxAeZPWGVch5RJHBti7fSh2Rc7XgYvaAKBzzbLkU5qj47+Ob6c9vVz1jPDMRu
 6JfIfkdmf/br16Msr
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> NULL check before kfree is unnecessary, so remove it.

Would you like to take similar update suggestions into account?
* 2019-09-04
  KVM: PPC: Book3S HV: Delete an unnecessary check before kfree() in __kvmhv_nested_page_fault()

* [-next] KVM: PPC: Book3S HV: remove redundant NULL check
  https://lkml.kernel.org/lkml/20200401130903.6576-1-chenzhou10@huawei.com/
  https://lore.kernel.org/patchwork/patch/1218800/

Regards,
Markus
